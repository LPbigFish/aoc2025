{- HLINT ignore "Use camelCase" -}
import System.IO

{-
>>> parse_ranges ["11-22", "95-115", "40-50"]
[(11,22),(95,115),(40,50)]
-}
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

{-
>>> find_dual_numbers $ parse_ranges ["11-22", "95-115"]
132
-}
find_dual_numbers :: [(Int, Int)] -> Int
find_dual_numbers = sum . concatMap (\(x,y) -> filter calculate_reverse [x..y])

{-
>>> calculate_reverse 22
True
>>> calculate_reverse 110
False
-}
calculate_reverse :: Int -> Bool
calculate_reverse number = let
    d = floor (logBase 10 (fromIntegral number)) + 1
    k = d `div` 2
    og = number `div` (10^k + 1)
    in number == og  *(10^k + 1) && og < 10^k

main :: IO ()
main = do
    let list = []
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    let file_lines = lines contents

    print file_lines

    print . find_dual_numbers $ parse_ranges file_lines

    hClose handle
