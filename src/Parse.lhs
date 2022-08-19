# Literate Parsing in Markdown

This file is a literate haskell-Markdown file, explaining and implementing a trivial parser combinator in Haskell

First we declare a module:

\begin{code}
module Parse where
\end{code}

Then we define our parser type. A parser must read some input - in this case a string - and attempt to match it. The simplest idea might be a predicate:

\begin{code}
type naiveParser = String -> Bool
\end{code}

Unfortunately this is not very useful - if we want parsers that can match anything beyond a constant string, then we're going to want to know _what_ was matched. So lets return that (if successful):

\begin{code}
type naiveParser' a = String -> Maybe a
\end{code}

Now we can at least extract some data out of the parser. However, although we can get a result out, we don't know what was done with the input. We'd like the ability to combine parsers in sequence, which means knowing where to start the next parser at. So at the very least, we'd need to output the remaining input:

\begin{code}
type naiveParser'' a = String -> Maybe (String, a)
\end{code}

Now our parser (if successful) can return where to begin the next parser, and also the parsed value. If it fails, we get Nothing. This is great in a successful case, but on failure, it would be useful to be able to indicate more clearly where errors happened - otherwise we get no information on how to fix our invalid input!

\begin{code}
data SimpleParseError = SimpleParseError { reason :: String }
type parserWithErrors a = String -> Either SimpleParseError (String, a)
\end{code}

Now every time we run a parser, we either fail - with a good reason - or we advance, producing a value and the remaining input to be parsed.

Let's try this and actually write some parsers and combinators. The most trivial parser (that still does useful work) just parses a single expected char:

\begin{code}
charP :: Char -> parserWithErrors Char
charP expected = \str -> case str of
                     (c:cs) if c == expected -> Right (cs, c)
                     [] -> Left endOfInput
                     (x:_) -> Left $ wrongChar x
                     where endOfInput = SimpleParseError "Expected " <> expected <>< ", found end of input"
                     wrongChar w = SimpleParseError "Expected " <> expected <>< ", found " <> w
\end{code}
