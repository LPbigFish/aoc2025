{- HLINT ignore "Use camelCase" -}
import System.IO
import Data.Char (digitToInt)

{-
>>> parse_batteries ["987654321111111", "811111111111119", "234234234234278"]
[[9,8,7,6,5,4,3,2,1,1,1,1,1,1,1],[8,1,1,1,1,1,1,1,1,1,1,1,1,1,9],[2,3,4,2,3,4,2,3,4,2,3,4,2,7,8]]
-}
parse_batteries :: [String] -> [[Int]]
parse_batteries = map (map digitToInt)

{-
>>> find_highest_capacity [2,3,4,2,3,4,2,3,4,2,3,4,2,7,8]
78
-}
find_highest_capacity :: [Int] -> Int
find_highest_capacity batteries = let
    first_max :: [Int] -> (Int, [Int])
    first_max [] = (0, [])
    first_max (x:xs) = go x [] xs
        where
        go :: Int -> [Int] -> [Int] -> (Int, [Int])
        go current_max since_max [x] = (current_max, since_max ++ [x]) 
        go current_max since_max (y:ys)
            | y > current_max = go y [] ys
            | otherwise = go current_max (since_max ++ [y]) ys
    (max1, rest1) = first_max batteries
    in max1 * 10 + maximum rest1

main :: IO ()
main = do
    let list = []
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    let file_lines = lines contents

    print file_lines

    (print . sum . map find_highest_capacity . parse_batteries) file_lines

    hClose handle
