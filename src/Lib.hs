module Lib
where

import Data.Primitive.SmallArray
import Data.Hashable
import Data.Word
import Data.Bits

-- TODO https://hackage.haskell.org/package/vec-0.3/docs/Data-Vec-Lazy.html
-- https://github.com/lehins/massiv


data Hamt key value = Empty -- ^ First, the entry is empty indicating that the key is not in the hash tree.
                    -- | Second the entry is a Key/Value pair and the
                    --   key either matches the desired key indicating success or not,
                    --   indicating failure.
                    | KeyVal key value
                    -- | Third, the entry has a 32 bit map
                    -- sub-hash table and a sub-trie pointer, Base, that points to an ordered list of the
                    -- non-empty sub-hash table entries.
                    | SubTry (SmallArray (Hamt key value))


-- this is the size of the smallarray
-- not related to the size of the bitmap of the hash!
branchingFactor :: Int
branchingFactor = 2^bitsTaken -- 5 bits are taken, so 2^5 = 32

bitsTaken :: Int
bitsTaken = 5

-- http://lampwww.epfl.ch/papers/idealhashtrees.pdf
-- TODO:
-- Take the next 5 bits of the hash and use them as an integer to index into the bit
-- Map. If this bit is a zero the hash table entry is empty indicating failure, otherwise,
-- it’s a one, so count the one bits below it using CTPOP and use the result as the
-- index into the non-empty entry list at Base.
lookup :: Hashable key => key -> Hamt key value -> Maybe value
lookup key _ = Nothing
  where
    keyHash :: Word32
    keyHash = toEnum $ hash key
