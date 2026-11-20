local fixture = dofile("tests/fixtures/forever_diagnostics.lua")
local addon = fixture.Load()
local api = fixture.API()
local safe = addon.SafeValues.New(api)
local context = addon.ClientContext.New(api, safe)
local meter = addon.DamageMeter.New(api, safe)

local roster, private = context:Roster()
assert(roster.members.player.class == "PRIEST" and roster.partyCount == 3)
assert(context:Instance().mapID == 33)
assert(private.byName.Same == false)

local sample = meter:Read(private)
assert(sample.capabilities.metrics.DamageDone == 0)
assert(sample.capabilities.availability.value == true)
assert(sample.byType.DamageDone.total.value == 0 and sample.byType.DamageDone.scan.state == "empty")
assert(sample.catalogue.sessions[1].id == 17 and sample.catalogue.sessions[1].name == nil)
assert(sample.byID.metrics.DamageDone.party.party1.total == 0)
assert(sample.byID.metrics.HealingDone.rows.secret == 1)
assert(sample.healing.sourceAmount == 42 and sample.healing.observedAmount == 42)
assert(sample.healing.observedMinusSourceAmount == 0 and sample.healing.spellIDs.missing == 3)
assert(sample.healing.matchedAmount == 32 and sample.healing.recipientJoins.ambiguous == 1)
assert(sample.healing.matchedAmountCount == 2 and sample.healing.recipientAmounts.secret == 1)
assert(sample.healing.selfObservedAmount == 12 and sample.healing.otherObservedAmount == 20)
assert(sample.healing.detailShape.single == 1 and sample.healing.detailShape.list == 1)
assert(sample.healing.detailShape.restricted == 1)

api.combat = true
local combat = meter:Read(nil, nil, true)
assert(combat.byType.DamageDone.state == "secret" and combat.byID == nil)
assert(api.drilldowns == 1)

api.combat = false
api.sessions = {}
assert(meter:Catalogue().state == "empty")
api.C_DamageMeter = nil
local absent = meter:Read(private)
assert(not absent.capabilities.namespace and absent.catalogue.state == "unavailable")
print("Damage meter tests passed")
