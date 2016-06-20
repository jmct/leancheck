import Test.LeanCheck.IO

main :: IO ()
main = do
  check $ \x -> (x::Int) + x == 2*x    -- should pass
--check $ \x -> (x::Int) + x == x      -- should fail, falsifiable
--check $ \x -> (x::Int) `div` x == 1  -- should fail, exception
