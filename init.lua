local solylib = require("solylib")
solylib.characters = require("solylib.characters")

local ATTACK_TYPE = {
    N = 0,
    H = 1,
    S = 2
}

local COMBO_STEP = {
    FIRST = 0,
    SECOND = 1,
    THIRD = 2
}

local SPECIAL_ATTACK_TYPE = {
    NONE = 0x0,
    STEAL_HP = 0x1,
    STEAL_TP = 0x2,
    STEAL_XP = 0x3,
    SACRIFICE_MESETA = 0x4,
    SACRIFICE_TP = 0x5,
    SACRIFICE_HP = 0x6,
    ICE = 0x7,
    PARALYZE = 0x8,
    FIRE = 0x9,
    THUNDER = 0xa,
    INSTAKILL = 0xb,
    CONFUSE = 0xc,
    DIVIDE = 0xd
}

local DIFFICULTY = {
    N = 0,
    H = 1,
    VH = 2,
    U = 3
}

local function ata_multiplier(attack_type, combo_step)
    local t = {
        [ATTACK_TYPE.N] = 1.0,
        [ATTACK_TYPE.H] = 0.7,
        [ATTACK_TYPE.S] = 0.5
    }
    local c = {
        [COMBO_STEP.FIRST] = 1.0,
        [COMBO_STEP.SECOND] = 1.3,
        [COMBO_STEP.THIRD] = 1.69,
    }
    return t[attack_type] * c[combo_step]
end

local function current_scene()
    return pso.read_u32(0x00aab384)
end

local function entity_rng_state_ptr(entity_ptr)
    return entity_ptr + 0x168
end

local PsoRng = {}

function PsoRng:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PsoRng:next_int()
    -- i don't know what scene 10 is but entity rng is not available in it
    if current_scene() == 10 then
        return 0
    end

    local next_counter = self:get_counter() + 1

    if next_counter < 0x38 then
        self:set_counter(next_counter)
    else
        local v24 = self:get_state(0x1) - self:get_state(0x20)
        local v1 = self:get_state(0x2) - self:get_state(0x21)
        local v2 = self:get_state(0x3) - self:get_state(0x22)
        local v3 = self:get_state(0x4) - self:get_state(0x23)
        local v4 = self:get_state(0x5) - self:get_state(0x24)
        local v5 = self:get_state(0x6) - self:get_state(0x25)
        self:set_counter(1)
        self:set_state(0x1, v24)
        self:set_state(0x2, v1)
        self:set_state(0x3, v2)
        self:set_state(0x4, v3)
        self:set_state(0x5, v4)
        self:set_state(0x6, v5)
        local v6 = self:get_state(0x7) - self:get_state(0x26)
        self:set_state(0x7, v6)
        local v7 = self:get_state(0x8) - self:get_state(0x27)
        self:set_state(0x8, v7)
        local v8 = self:get_state(0x9) - self:get_state(0x28)
        self:set_state(0x9, v8)
        local v9 = self:get_state(0xa) - self:get_state(0x29)
        self:set_state(0xa, v9)
        local v10 = self:get_state(0xb) - self:get_state(0x2a)
        self:set_state(0xb, v10)
        local v11 = self:get_state(0xc) - self:get_state(0x2b)
        self:set_state(0xc, v11)
        local v12 = self:get_state(0xd) - self:get_state(0x2c)
        self:set_state(0xd, v12)
        local v13 = self:get_state(0xe) - self:get_state(0x2d)
        self:set_state(0xe, v13)
        local v14 = self:get_state(0xf) - self:get_state(0x2e)
        self:set_state(0xf, v14)
        local v15 = self:get_state(0x10) - self:get_state(0x2f)
        self:set_state(0x10, v15)
        local v16 = self:get_state(0x11) - self:get_state(0x30)
        self:set_state(0x11, v16)
        local v17 = self:get_state(0x12) - self:get_state(0x31)
        self:set_state(0x12, v17)
        local v18 = self:get_state(0x13) - self:get_state(0x32)
        self:set_state(0x13, v18)
        local v19 = self:get_state(0x14) - self:get_state(0x33)
        self:set_state(0x14, v19)
        local v20 = self:get_state(0x15) - self:get_state(0x34)
        self:set_state(0x15, v20)
        local v21 = self:get_state(0x16) - self:get_state(0x35)
        self:set_state(0x16, v21)
        local v22 = self:get_state(0x17) - self:get_state(0x36)
        self:set_state(0x17, v22)
        local v23 = self:get_state(0x18) - self:get_state(0x37)
        self:set_state(0x18, v23)
        v24 = self:get_state(0x19) - v24
        self:set_state(0x19, v24)
        v1 = self:get_state(0x1a) - v1
        self:set_state(0x1a, v1)
        v2 = self:get_state(0x1b) - v2
        self:set_state(0x1b, v2)
        v3 = self:get_state(0x1c) - v3
        self:set_state(0x1c, v3)
        v4 = self:get_state(0x1d) - v4
        v5 = self:get_state(0x1e) - v5
        self:set_state(0x1d, v4)
        self:set_state(0x1e, v5)
        v6 = self:get_state(0x1f) - v6
        self:get_state(0x1f, v6)
        self:set_state(0x20, self:get_state(0x20) - v7)
        self:set_state(0x21, self:get_state(0x21) - v8)
        self:set_state(0x22, self:get_state(0x22) - v9)
        self:set_state(0x23, self:get_state(0x23) - v10)
        self:set_state(0x24, self:get_state(0x24) - v11)
        self:set_state(0x25, self:get_state(0x25) - v12)
        self:set_state(0x26, self:get_state(0x26) - v13)
        self:set_state(0x27, self:get_state(0x27) - v14)
        self:set_state(0x28, self:get_state(0x28) - v15)
        self:set_state(0x29, self:get_state(0x29) - v16)
        self:set_state(0x2a, self:get_state(0x2a) - v17)
        self:set_state(0x2b, self:get_state(0x2b) - v18)
        self:set_state(0x2c, self:get_state(0x2c) - v19)
        self:set_state(0x2d, self:get_state(0x2d) - v20)
        self:set_state(0x2e, self:get_state(0x2e) - v21)
        self:set_state(0x2f, self:get_state(0x2f) - v22)
        self:set_state(0x30, self:get_state(0x30) - v23)
        self:set_state(0x31, self:get_state(0x31) - v24)
        self:set_state(0x32, self:get_state(0x32) - v1)
        self:set_state(0x33, self:get_state(0x33) - v2)
        self:set_state(0x34, self:get_state(0x34) - v3)
        self:set_state(0x35, self:get_state(0x35) - v4)
        self:set_state(0x36, self:get_state(0x36) - v5)
        self:set_state(0x37, self:get_state(0x37) - v6)
        next_counter = 1
    end

    return self:get_state(next_counter)
end

function PsoRng:next_float()
    return bit.rshift(self:next_int(), 0x10) / 65536.0
end

local EntityRng = PsoRng:new()

function EntityRng:new(entity_ptr)
    local o = {entity_ptr = entity_ptr}
    setmetatable(o, self)
    self.__index = self
    return o
end

function EntityRng:get_counter()
    local rng_state_ptr = entity_rng_state_ptr(self.entity_ptr)
    return pso.read_u32(rng_state_ptr)
end

function EntityRng:set_counter(value)
    -- nop
end

function EntityRng:get_state(index)
    return pso.read_u32(entity_rng_state_ptr(self.entity_ptr) + 4 + index * 4)
end

function EntityRng:set_state(index, value)
    -- nop
end

local FakeRng = PsoRng:new()

function FakeRng:new(counter, state)
    local o = {counter = counter, state = state}
    setmetatable(o, self)
    self.__index = self
    return o
end

function FakeRng:get_counter()
    return self.counter
end

function FakeRng:set_counter(value)
    self.counter = value
end

function FakeRng:get_state(index)
    return self.state[index]
end

function FakeRng:set_state(index, value)
    self.state[index] = value
end

function FakeRng:from_entity(entity_ptr)
    local rng_ptr = entity_rng_state_ptr(entity_ptr)
    local counter = pso.read_u32(rng_ptr)
    local state = {}

    for i = 0, 55 do
        state[i] = pso.read_u32(rng_ptr + 4 + i * 4)
    end

    return FakeRng:new(counter, state)
end

local function entity_count()
    return pso.read_u32(0x00aae164)
end

local function player_count()
    return pso.read_u32(0x00aae168)
end

local function find_entity_by_id(entity_id)
    local player_count = player_count()

    for i = 0, entity_count() - 1 do
        local entity_ptr = pso.read_u32(0x00aad720 + (i + player_count) * 4)

        if entity_ptr ~= 0 and entity_id == pso.read_i16(entity_ptr + 0x1c) then
            return entity_ptr
        end
    end

    return 0
end

local function entity_horizontal_distance(a_ptr, b_ptr)
    local ax = pso.read_f32(a_ptr + 0x38)
    local az = pso.read_f32(a_ptr + 0x40)
    local bx = pso.read_f32(b_ptr + 0x38)
    local bz = pso.read_f32(b_ptr + 0x40)
    local x = ax - bx
    local z = az - bz
    local d = z * z + x * x
    if d < 0 then
        return -math.sqrt(-d)
    end
    return math.sqrt(d)
end

local function target_entity_ptr()
    local player_ptr = solylib.characters.GetSelf()

    if player_ptr == 0 then
        return 0
    end

    local unknown_ptr = pso.read_u32(player_ptr + 0x18)

    if unknown_ptr == 0 then
        return 0
    end

    local target_id = pso.read_i16(unknown_ptr + 0x108c)

    if target_id == -1 then
        return 0
    end

    return find_entity_by_id(target_id)
end

local function character_class_flags(player_ptr)
    return pso.read_u32(player_ptr + 0x2e8)
end

local function character_buff_flags(player_ptr)
    return pso.read_u32(player_ptr + 0x324)
end

local function character_is_ranger(player_ptr)
    return bit.band(character_class_flags(player_ptr), 0x20) ~= 0
end

local function character_is_android(player_ptr)
    return bit.band(character_class_flags(player_ptr), 0x4) ~= 0
end

local function smartlink_buff_active(player_ptr)
    local flags_ptr = character_buff_flags(player_ptr)

    if flags_ptr == 0 then
        return false
    end

    return pso.read_u16(flags_ptr + 3 * 2) ~= 0
end

local function v50x_status_boost(player_ptr)
    local flags_ptr = character_buff_flags(player_ptr)

    if flags_ptr == 0 then
        return 1.0
    end

    local value = pso.read_u16(flags_ptr)

    if value == 0 then
        return 1.0
    end

    return value * 0.01
end

local function v50x_instakill_boost(player_ptr)
    local flags_ptr = character_buff_flags(player_ptr)

    if flags_ptr == 0 then
        return 1.0
    end

    local value = pso.read_u16(flags_ptr + 2)

    if value == 0 then
        return 1.0
    end

    return value * 0.01
end

local function evp(entity_ptr)
    return pso.read_u16(entity_ptr + 0x2d0)
end

local function total_ata(entity_ptr)
    return pso.read_u16(entity_ptr + 0x2d4)
end

local function esp(entity_ptr)
    local stats_ptr = pso.read_u32(entity_ptr + 0x2b4)

    if stats_ptr == 0 then
        return 0
    end

    return pso.read_u16(stats_ptr + 0xe)
end

local function edk(entity_ptr)
    return pso.read_u16(entity_ptr + 0x2fc)
end

local function is_attacking(player_ptr)
    return pso.read_i16(player_ptr + 0x8be) ~= -1
end

local function weapon_special_attack_type(player_ptr)
    return pso.read_u16(player_ptr + 0x116)
end

local function weapon_special_attack_power(player_ptr)
    return pso.read_u16(player_ptr + 0x118)
end

local function weapon(player_ptr)
    return pso.read_u32(player_ptr + 0xdf8 + 0x18)
end

local function item_id(item_ptr)
    local bytes = {}
    pso.read_mem(bytes, item_ptr + 0xf1, 4)
    return bytes
end

local function entity_index(entity_ptr)
    return pso.read_u16(entity_ptr + 0x1c)
end

local function difficulty()
    return pso.read_u16(0x00a9cd68)
end

local function current_map()
    return pso.read_u32(0x00aafc9c)
end

local function map_is_boss_map(map)
    return pso.read_u32(0x0097f040 + map * 4) == 0xb
end

local function next_combo_step(player_ptr)
    if not is_attacking(player_ptr) then
        return COMBO_STEP.FIRST
    end

    local next_step = pso.read_u32(player_ptr + 0x8b4) + 1

    if next_step > COMBO_STEP.THIRD then
        return COMBO_STEP.THIRD
    end

    return next_step
end

local function special_base_activation_chance(special_power, resistance, special_reduction)
    return (special_power - resistance) * 0.01 * special_reduction
end

local function special_attack_will_activate_against_enemy(player_ptr, enemy_ptr, special_type, rng)
    local special_power = weapon_special_attack_power(player_ptr)
    local difficulty = difficulty()

    -- android boost
    if difficulty == DIFFICULTY.U and
       character_is_android(player_ptr) and
       special_type ~= SPECIAL_ATTACK_TYPE.INSTAKILL and
       special_type ~= SPECIAL_ATTACK_TYPE.FIRE and
       special_type ~= SPECIAL_ATTACK_TYPE.THUNDER then
        special_power = special_power + 30
    end

    local special_reduction = 1.0
    local weapon = weapon(player_ptr)

    -- check if weapon should have reduced special
    if weapon ~= 0 then
        local item_id = item_id(weapon)
        local grp2 = item_id[3]

        if 1 < grp2 then
            if grp2 < 5 then
                special_reduction = 0.5
            else
                if grp2 == 5 or (7 < grp2 and grp2 < 10) then
                    special_reduction = 0.33
                end
            end
        end
    end

    local random = rng:next_float()

    -- activation
    if special_type == SPECIAL_ATTACK_TYPE.NONE or
       special_type == SPECIAL_ATTACK_TYPE.STEAL_HP or
       special_type == SPECIAL_ATTACK_TYPE.STEAL_TP or
       special_type == SPECIAL_ATTACK_TYPE.STEAL_XP or
       special_type == SPECIAL_ATTACK_TYPE.SACRIFICE_MESETA or
       special_type == SPECIAL_ATTACK_TYPE.SACRIFICE_TP or
       special_type == SPECIAL_ATTACK_TYPE.FIRE or
       special_type == SPECIAL_ATTACK_TYPE.THUNDER or -- TODO: shock check?
       special_type == SPECIAL_ATTACK_TYPE.SACRIFICE_HP then
        return true
    elseif special_type == SPECIAL_ATTACK_TYPE.ICE then
        local activation_chance = special_base_activation_chance(special_power, esp(enemy_ptr), special_reduction)
        local activation_cap = 0.4

        if difficulty == DIFFICULTY.U then
            activation_cap = 0.2
        end

        activation_chance = activation_chance * v50x_status_boost(player_ptr)

        return rng:next_float() < activation_chance
    elseif special_type == SPECIAL_ATTACK_TYPE.PARALYZE then
        local activation_chance = special_base_activation_chance(special_power, esp(enemy_ptr), special_reduction)
        activation_chance = activation_chance * v50x_status_boost(player_ptr)
        return random < activation_chance
    elseif special_type == SPECIAL_ATTACK_TYPE.INSTAKILL then
        local activation_chance = (special_power - edk(enemy_ptr)) * 0.01 * special_reduction

        -- not sure what this is
        if entity_index(enemy_ptr) < 0x1000 then
            activation_chance = activation_chance - 0.5
        end

        local v50x_total = v50x_status_boost(player_ptr) + v50x_instakill_boost(player_ptr)
        activation_chance = activation_chance * v50x_total

        if map_is_boss_map(current_map()) then
            return false
        end

        return random < activation_chance
    elseif special_type == SPECIAL_ATTACK_TYPE.CONFUSE then
        local activation_chance = special_base_activation_chance(special_power, esp(enemy_ptr), special_reduction)
        activation_chance = activation_chance * v50x_status_boost(player_ptr)
        -- XXX: confuse hits even if it doesn't activate...
        return random < activation_chance
    elseif special_type == SPECIAL_ATTACK_TYPE.DIVIDE then
        if map_is_boss_map(current_map()) then
            return false
        end

        -- not sure what this is
        if entity_index(entity_ptr) < 0x1000 then
            return false
        end

        return random < 0.5
    end
end

local function ranged_attack_will_hit_enemy(player_ptr, enemy_ptr, ata_multiplier, rng)
    rng = rng or EntityRng:new(enemy_ptr)

    local hit_chance = (evp(enemy_ptr) * -0.2 + total_ata(player_ptr) * ata_multiplier) * 0.01

    if not character_is_ranger(player_ptr) and not smartlink_buff_active(player_ptr) then
        hit_chance = hit_chance - entity_horizontal_distance(player_ptr, enemy_ptr) * 0.01 * 0.33333334
    end

    if hit_chance <= 0.0 then
        return false
    end

    return rng:next_float() <= hit_chance
end

local function attack_will_hit_enemy(attack_type)
    local player_ptr = solylib.characters.GetSelf()

    if player_ptr == 0 then
        return false
    end

    local target_ptr = target_entity_ptr()

    if target_ptr == 0 then
        return false
    end

    local ata_multiplier = ata_multiplier(attack_type, next_combo_step(player_ptr))

    local rng = FakeRng:from_entity(target_ptr)

    if ranged_attack_will_hit_enemy(player_ptr, target_ptr, ata_multiplier, rng) then
        if attack_type == ATTACK_TYPE.S then
            local special_type = weapon_special_attack_type(player_ptr)
            return special_attack_will_activate_against_enemy(player_ptr, target_ptr, special_type, rng)
        end

        return true
    end

    return false
end

local function present()
    if imgui.Begin("unrandom", nil, {}) then
        imgui.Text("Next attack will hit?")
        imgui.Text("N: " .. tostring(attack_will_hit_enemy(ATTACK_TYPE.N)))
        imgui.Text("H: " .. tostring(attack_will_hit_enemy(ATTACK_TYPE.H)))
        imgui.Text("S: " .. tostring(attack_will_hit_enemy(ATTACK_TYPE.S)))
    end
    imgui.End()
end

local function init()
    return {
        name = "unrandom",
        present = present
    }
end

return {
    __addon = {
        init = init
    }
}
