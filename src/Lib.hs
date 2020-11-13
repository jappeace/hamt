module Lib
where

import Data.Primitive.SmallArray
import Data.Hashable
import Data.Word

-- TODO https://hackage.haskell.org/package/vec-0.3/docs/Data-Vec-Lazy.html
-- https://github.com/lehins/massiv


data Hamt key value = Empty
                    | KeyVal key value
                    | SubTry (SmallArray (Hamt key value))

-- this is the size of the smallarray
-- not related to the size of the bitmap of the hash!
someBranchingFactor = 32

lookup :: Hashable key => key -> Hamt key value -> Maybe value
lookup key _ = Nothing
  where
    keyHash :: Word32
    keyHash = toEnum $ hash key
