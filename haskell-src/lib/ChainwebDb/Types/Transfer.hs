{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module ChainwebDb.Types.Transfer where

----------------------------------------------------------------------------
import BasePrelude
import Data.Scientific
import Database.Beam
import Database.Beam.Backend.SQL.SQL92
import Database.Beam.Postgres
import Database.Beam.Postgres.Syntax
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromField
------------------------------------------------------------------------------
import ChainwebDb.Types.Block
import ChainwebDb.Types.Common
import ChainwebDb.Types.PgText
------------------------------------------------------------------------------
data TransferT f = Transfer
  { _tr_block :: PrimaryKey BlockT f
  , _tr_requestkey :: C f ReqKeyOrCoinbase
  , _tr_chainid :: C f Int64
  , _tr_height :: C f Int64
  , _tr_idx :: C f Int64
  , _tr_modulename :: C f PgText
  , _tr_moduleHash :: C f PgText
  , _tr_from_acct :: C f PgText
  , _tr_to_acct :: C f PgText
  , _tr_amount :: C f KDAScientific
  }
  deriving stock (Generic)
  deriving anyclass (Beamable)

type Transfer = TransferT Identity
type TransferId = PrimaryKey TransferT Identity

instance Table TransferT where
  data PrimaryKey TransferT f = TransferId (PrimaryKey BlockT f) (C f ReqKeyOrCoinbase) (C f Int64) (C f Int64) (C f PgText)
    deriving stock (Generic)
    deriving anyclass (Beamable)
  primaryKey = TransferId <$> _tr_block <*> _tr_requestkey <*> _tr_chainid <*> _tr_idx <*> _tr_moduleHash

newtype KDAScientific = KDAScientific { getKDAScientific :: Scientific }
  deriving newtype (Eq, Show, HasSqlValueSyntax PgValueSyntax, ToField, FromField, FromBackendRow Postgres)
