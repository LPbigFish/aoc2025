{- HLINT ignore "Use camelCase" -}
import System.IO

parse_ranges :: [String] -> [(Int, Int)]
parse_ranges = map find
  where
    find :: String -> (Int, Int)
    find = convert . foldl (\(left, right, found_char) char ->
            if not found_char then
                (left ++ ([char | char /= '-']), right, char == '-' || found_char)
            else
                (left, right ++ [char], found_char))
           ("", "", False)
    convert :: (String, String, a3) -> (Int, Int)
    convert (x, y, _) = (read x, read y)

find_dual_numbers :: [(Int, Int)] -> [Int]
find_dual_numbers = concatMap (\(x,y) -> filter calculate_reverse' [x..y])

{-
>>> calculate_reverse' 5050505
False
>>> calculate_reverse' 900900
True
-}
calculate_reverse' :: Int -> Bool
calculate_reverse' number = let
    d = log_it number
    k = d `div` 2
    og = zipWith (\x y -> number `rem` y == 0 && log_it (number `div` y) == x) [1..] (calculate_mask d)
    in or og

log_it :: Int -> Int
log_it number = floor ( logBase 10 (fromIntegral number)) + 1

{-
>>> calculate_mask 6
[111111,10101,1001]
>>> calculate_mask 12
[111111111111,10101010101,1001001001,100010001,10000100001,1000001]
-}

calculate_mask :: Int -> [Int]
calculate_mask d = let
    k = d `div` 2
    in [ sum [ 10^a | a <- [0,i..(d-1)] ] | i <- [1..k] ]


main :: IO ()
main = do
    let list = []
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    let file_lines = lines contents

    print file_lines

    print . sum . find_dual_numbers $ parse_ranges file_lines

    hClose handle
