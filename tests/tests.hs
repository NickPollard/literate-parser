import System.Exit (exitFailure, exitSuccess)
import Test.Tasty
import Test.Tasty.HUnit

main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" [unitTests]

unitTests :: TestTree
unitTests = testGroup "UnitTests" [ test ]

test :: TestTree
test = testCase "foo" $ return ()

-- TODO - write some actual tests; use comparators etc. to get meaningful output
