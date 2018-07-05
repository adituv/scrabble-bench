module Main(main) where

import           Criterion.Main

import           Control.DeepSeq     (NFData (..))
import           Control.Exception   (evaluate)
import           Data.Bifunctor      (first)
import           Data.Function       ((&))
import           Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HashMap
import           Data.IntMap.Strict  (IntMap)
import qualified Data.IntMap.Strict  as IntMap
import           Data.List           (foldl')
import           Data.Map.Strict     (Map)
import qualified Data.Map.Strict     as Map
import           Data.Maybe          (fromMaybe)

scoresList :: [(Char, Int)]
scoresList =
  zip
    ['a' .. 'z']
    [ 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3
    , 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10
    ]

scoresMap :: Map Char Int
scoresMap = Map.fromDistinctAscList scoresList

scoresHashMap :: HashMap Char Int
scoresHashMap = HashMap.fromList scoresList

scoresIntMap :: IntMap Int
scoresIntMap = IntMap.fromDistinctAscList $ fmap (first fromEnum) scoresList

sum' :: [Int] -> Int
sum' = foldl' (+) 0

scrabbleBench :: (Char -> Int) -> Int
scrabbleBench f = sum' $ fmap f ['a' .. 'z']

listFindWithDefault :: Eq k => v -> k -> [(k, v)] -> v
listFindWithDefault def k xs = fromMaybe def (lookup k xs)

main :: IO ()
main = do
  evaluate (rnf scoresList)
  defaultMain
    [ bgroup
        "scrabble"
        [ bench "list" $
          whnf scrabbleBench (\k -> listFindWithDefault 0 k scoresList)
        , bench "map" $
          whnf scrabbleBench (\k -> Map.findWithDefault 0 k scoresMap)
        , bench "hashmap" $
          whnf scrabbleBench (\k -> HashMap.lookupDefault 0 k scoresHashMap)
        , bench "intmap" $
          whnf
            scrabbleBench
            (\k -> IntMap.findWithDefault 0 (fromEnum k) scoresIntMap)
        ]
    ]
