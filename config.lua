Config = {}

-- ============================================================================
-- PERMISSIONS
-- ============================================================================
Config.Permissions = {
    admin       = 'dbadmin.admin',
    moderator   = 'dbadmin.moderator',
    developer   = 'dbadmin.developer',
    troll       = 'dbadmin.troll',
    reports     = 'dbadmin.reports',
    finances    = 'dbadmin.finances',
}

-- ============================================================================
-- COMMAND / KEYBIND
-- ============================================================================
Config.OpenCommand = 'admin'
Config.OpenKey     = 'PGUP'

-- ============================================================================
-- PLAYER BLIPS
-- ============================================================================
Config.EnablePlayerBlips = true
Config.BlipUpdateInterval = 1000
Config.BlipScale = 0.6

-- ============================================================================
-- REPORTS
-- ============================================================================
Config.Reports = {
    EnableCommand = true,
    Command = 'report',

    Webhooks = {
        Main     = 'YOUR_WEBHOOK_URL_HERE',
        Bug      = '',
        Player   = '',
        Question = '',
    },

    Discord = {
        EnableRoleMention = true,
        RolesToMention = {
            'YOUR_DISCORD_ROLE_ID_HERE',
        },
    },

    WebhookColors = {
        bug      = 16711680,
        player   = 16776960,
        question = 65280,
        open     = 3447003,
        claimed  = 16776960,
        resolved = 65280,
        closed   = 10197915,
    },

    NearbyDistance = 50.0,
    Cooldown = 60,

    Categories = {
        { value = 'bug',      label = 'Bug Report' },
        { value = 'player',   label = 'Player Report' },
        { value = 'question', label = 'Question' },
    },
}

-- ============================================================================
-- HORSES & EQUIPMENT
-- ============================================================================
Config.HorseSpawnDistance = 50.0
Config.DefaultHorseSaddle = 0xAD4A6355  -- Saddle 1 (default)

-- Available Horses (verified RedM models)
Config.AdminHorse = {
    { horsename = 'Arabian White',           horsehash = 'A_C_Horse_Arabian_White' },
    { horsename = 'Arabian Black',           horsehash = 'A_C_Horse_Arabian_Black' },
    { horsename = 'Arabian Rose Gray',       horsehash = 'A_C_Horse_Arabian_RoseGrey' },
    { horsename = 'Thoroughbred',            horsehash = 'A_C_Horse_Thoroughbred_BlackChestnut' },
    { horsename = 'Missouri Fox Trotter',    horsehash = 'A_C_Horse_MissouriFoxTrotter_SableChampagne' },
    { horsename = 'Mustang',                 horsehash = 'A_C_Horse_Mustang_WildBay' },
    { horsename = 'Shire',                   horsehash = 'A_C_Horse_Shire_DarkBay' },
    { horsename = 'Appaloosa',               horsehash = 'A_C_Horse_Appaloosa_Blanket' },
    { horsename = 'Ardennes',                horsehash = 'A_C_Horse_Ardennes_BayRoan' },
    { horsename = 'Belgian',                 horsehash = 'A_C_Horse_Belgian_BlondChestnut' },
    { horsename = 'Hungarian Halfbred',      horsehash = 'A_C_Horse_HungarianHalfbred_DarkDappleGrey' },
    { horsename = 'Kentucky Saddler',        horsehash = 'A_C_Horse_KentuckySaddle_Black' },
    { horsename = 'Morgan',                  horsehash = 'A_C_Horse_Morgan_Bay' },
    { horsename = 'Turkoman',                horsehash = 'A_C_Horse_Turkoman_Gold' },
    { horsename = 'Nokota',                  horsehash = 'A_C_Horse_Nokota_BlueRoan' },
    { horsename = 'Dutch Warmblood',         horsehash = 'A_C_Horse_DutchWarmblood_ChocolateRoan' },
}

-- Saddles
Config.Saddles = {
    { label = 'No Saddle', hash = 0 },
    { label = 'Saddle 1',  hash = 0xAD4A6355 }, { label = 'Saddle 2',  hash = 0x8FFCF06B },
    { label = 'Saddle 3',  hash = 0x5546EB7A }, { label = 'Saddle 4',  hash = 0x8E64DDB5 },
    { label = 'Saddle 5',  hash = 0x7092A211 }, { label = 'Saddle 6',  hash = 0xC0C04297 },
    { label = 'Saddle 7',  hash = 0xBE703DF7 }, { label = 'Saddle 8',  hash = 0xE5510BB8 },
    { label = 'Saddle 9',  hash = 0x7D795D72 }, { label = 'Saddle 10', hash = 0x0522CCED },
    { label = 'Saddle 11', hash = 0x5B45F932 }, { label = 'Saddle 12', hash = 0x219D85E2 },
    { label = 'Saddle 13', hash = 0x7DBB3E1C }, { label = 'Saddle 14', hash = 0x4C1A5ADB },
    { label = 'Saddle 15', hash = 0xF1BAA60D }, { label = 'Saddle 16', hash = 0xE6488B58 },
    { label = 'Saddle 17', hash = 0xD2FA64BC }, { label = 'Saddle 18', hash = 0x189F7005 },
    { label = 'Saddle 19', hash = 0xF7682D97 }, { label = 'Saddle 20', hash = 0x1D0BF8F2 },
    { label = 'Saddle 21', hash = 0x0A39D34E }, { label = 'Saddle 22', hash = 0xBFD09512 },
    { label = 'Saddle 23', hash = 0x17153A45 }, { label = 'Saddle 24', hash = 0x05D717C9 },
    { label = 'Saddle 25', hash = 0x4B372288 }, { label = 'Saddle 26', hash = 0x78F07DFA },
    { label = 'Saddle 27', hash = 0x2E4668A3 }, { label = 'Saddle 28', hash = 0x1C14443F },
    { label = 'Saddle 29', hash = 0x353FC03C }, { label = 'Saddle 30', hash = 0xD97573C1 },
    { label = 'Saddle 31', hash = 0xF3BEA853 }, { label = 'Saddle 32', hash = 0x01F7C4C5 },
    { label = 'Saddle 33', hash = 0x106961A8 }, { label = 'Saddle 34', hash = 0x2ECD9E70 },
    { label = 'Saddle 35', hash = 0x3D0C3AED }, { label = 'Saddle 36', hash = 0xF94D5623 },
    { label = 'Saddle 37', hash = 0x3F9F62CE }, { label = 'Saddle 38', hash = 0x150D0DAA },
    { label = 'Saddle 39', hash = 0xEB1139AB }, { label = 'Saddle 40', hash = 0xC04FE429 },
    { label = 'Saddle 41', hash = 0x0DE47F51 }, { label = 'Saddle 42', hash = 0x5BBC54C3 },
    { label = 'Saddle 43', hash = 0x8D163776 }, { label = 'Saddle 44', hash = 0x3E949A74 },
    { label = 'Saddle 45', hash = 0x70BB7EC1 }, { label = 'Saddle 46', hash = 0xD11CBF82 },
    { label = 'Saddle 47', hash = 0xBA6A921E }, { label = 'Saddle 48', hash = 0xD225CCA0 },
    { label = 'Saddle 49', hash = 0x6D403492 }, { label = 'Saddle 50', hash = 0xBB335077 },
    { label = 'Saddle 51', hash = 0x8D9D754C }, { label = 'Saddle 52', hash = 0x5B6390D9 },
    { label = 'Saddle 53', hash = 0x14168240 }, { label = 'Saddle 54', hash = 0x7FD859C2 },
    { label = 'Saddle 55', hash = 0x87F421F7 }, { label = 'Saddle 56', hash = 0xC1AF1568 },
    { label = 'Saddle 57', hash = 0xF36A78DE }, { label = 'Saddle 58', hash = 0x9CD94BC1 },
    { label = 'Saddle 59', hash = 0xCE8C2F22 }, { label = 'Saddle 60', hash = 0x2844E292 },
    { label = 'Saddle 61', hash = 0xC10B5450 }, { label = 'Saddle 62', hash = 0xD2C8F7CB },
    { label = 'Saddle 63', hash = 0xE5B31D9F }, { label = 'Saddle 64', hash = 0xF373B920 },
    { label = 'Saddle 65', hash = 0x7A23C686 }, { label = 'Saddle 66', hash = 0x88C363C5 },
    { label = 'Saddle 67', hash = 0xB5802A5F }, { label = 'Saddle 68', hash = 0x7C2C580C },
    { label = 'Saddle 69', hash = 0x6FEABF89 }, { label = 'Saddle 70', hash = 0xA21923E5 },
    { label = 'Saddle 71', hash = 0x93DA8768 }, { label = 'Saddle 72', hash = 0xA8DB3175 },
    { label = 'Saddle 73', hash = 0x9B1C95F8 }, { label = 'Saddle 74', hash = 0x7C19770A },
    { label = 'Saddle 75', hash = 0xA1154105 }, { label = 'Saddle 76', hash = 0xB357E58A },
    { label = 'Saddle 77', hash = 0x8DD09A7C }, { label = 'Saddle 78', hash = 0x9FF23EBF },
    { label = 'Saddle 79', hash = 0xFC6AF7AF }, { label = 'Saddle 80', hash = 0xB9BE555D },
    { label = 'Saddle 81', hash = 0x01EC65C0 }, { label = 'Saddle 82', hash = 0x0F2F0045 },
    { label = 'Saddle 83', hash = 0xE52BAC3F }, { label = 'Saddle 84', hash = 0xF4B14B4A },
    { label = 'Saddle 85', hash = 0x3827D232 }, { label = 'Saddle 86', hash = 0xDE5A2905 },
    { label = 'Saddle 87', hash = 0xEC882931 }, { label = 'Saddle 88', hash = 0xDA36048D },
    { label = 'Saddle 89', hash = 0xC7FC601A }, { label = 'Saddle 90', hash = 0xB7B33F88 },
    { label = 'Saddle 91', hash = 0xA7AC9F7B }, { label = 'Saddle 92', hash = 0x9533FA8E },
    { label = 'Saddle 93', hash = 0xE039FC0F }, { label = 'Saddle 94', hash = 0xF687A8AA },
    { label = 'Saddle 95', hash = 0x47D2CB3F }, { label = 'Saddle 96', hash = 0x15FB6791 },
    { label = 'Saddle 97', hash = 0xE36C8274 }, { label = 'Saddle 98', hash = 0x40C53D24 },
    { label = 'Saddle 99', hash = 0x64CEC6DF }, { label = 'Saddle 100', hash = 0x9E0C3959 },
    { label = 'Saddle 101', hash = 0x90489DD2 }, { label = 'Saddle 102', hash = 0xBC52F5E6 },
    { label = 'Saddle 103', hash = 0xD61B2996 }, { label = 'Saddle 104', hash = 0xC7D58D0B },
    { label = 'Saddle 105', hash = 0x2BEA8ED4 }, { label = 'Saddle 106', hash = 0x8DABACD7 },
    { label = 'Saddle 107', hash = 0x6384D886 }, { label = 'Saddle 108', hash = 0x694DE418 },
    { label = 'Saddle 109', hash = 0x60DE5335 }, { label = 'Saddle 110', hash = 0x76887E89 },
    { label = 'Saddle 111', hash = 0x2E216DBC }, { label = 'Saddle 112', hash = 0x5A9E4F6C },
    { label = 'Saddle 113', hash = 0x2F8C7941 }, { label = 'Saddle 114', hash = 0xFD4E14C5 },
    { label = 'Saddle 115', hash = 0xB61F0668 }, { label = 'Saddle 116', hash = 0x21E8DDFA },
    { label = 'Saddle 117', hash = 0xDA84CF33 }, { label = 'Saddle 118', hash = 0xC454830C },
    { label = 'Saddle 119', hash = 0xD6BF27E1 }, { label = 'Saddle 120', hash = 0x24F24446 },
    { label = 'Saddle 121', hash = 0x0F4118E4 }, { label = 'Saddle 122', hash = 0x0306806F },
    { label = 'Saddle 123', hash = 0x70C65BED }, { label = 'Saddle 124', hash = 0xC76C46D9 },
    { label = 'Saddle 125', hash = 0x2E3F3A62 }, { label = 'Saddle 126', hash = 0x660B29F9 },
    { label = 'Saddle 127', hash = 0x335DC49F }, { label = 'Saddle 128', hash = 0xFCE1D7A4 },
    { label = 'Saddle 129', hash = 0x093B7057 }, { label = 'Saddle 130', hash = 0x20359E53 },
    { label = 'Saddle 131', hash = 0x534A7D59 }, { label = 'Saddle 132', hash = 0xD7FC86BF },
    { label = 'Saddle 133', hash = 0xE9B7AA35 }, { label = 'Saddle 134', hash = 0x6C622F8C },
    { label = 'Saddle 135', hash = 0x8E22730C }, { label = 'Saddle 136', hash = 0x1EE21489 },
}

-- Blankets
Config.Blankets = {
    { label = 'No Blanket', hash = 0 },
    { label = 'Blanket 1',  hash = 0x0FAE487F }, { label = 'Blanket 2',  hash = 0x2286EE30 },
    { label = 'Blanket 3',  hash = 0x41D52CD8 }, { label = 'Blanket 4',  hash = 0xC4C732B2 },
    { label = 'Blanket 5',  hash = 0xFDF4250B }, { label = 'Blanket 6',  hash = 0x508B80B9 },
    { label = 'Blanket 7',  hash = 0x67CAAF37 }, { label = 'Blanket 8',  hash = 0xEBB4B70D },
    { label = 'Blanket 9',  hash = 0xFA1153C6 }, { label = 'Blanket 10', hash = 0x0F537E4A },
    { label = 'Blanket 11', hash = 0x97EBE669 }, { label = 'Blanket 12', hash = 0x269583CA },
    { label = 'Blanket 13', hash = 0x3973A986 }, { label = 'Blanket 14', hash = 0x4A294AF1 },
    { label = 'Blanket 15', hash = 0xED0190A3 }, { label = 'Blanket 16', hash = 0xBBF05395 },
    { label = 'Blanket 17', hash = 0x823A602A }, { label = 'Blanket 18', hash = 0x533A022A },
    { label = 'Blanket 19', hash = 0xB0F7BDA4 }, { label = 'Blanket 20', hash = 0xFDC3D6D3 },
    { label = 'Blanket 21', hash = 0x6B2084E5 }, { label = 'Blanket 22', hash = 0x78FB209A },
    { label = 'Blanket 23', hash = 0x8FAD4DFE }, { label = 'Blanket 24', hash = 0x9DE0EA65 },
    { label = 'Blanket 25', hash = 0x342916F3 }, { label = 'Blanket 26', hash = 0xAD283105 },
    { label = 'Blanket 27', hash = 0xC2EF5C93 }, { label = 'Blanket 28', hash = 0xC8A467FD },
    { label = 'Blanket 29', hash = 0x4655E362 }, { label = 'Blanket 30', hash = 0xDBEF0E96 },
    { label = 'Blanket 31', hash = 0x7951D487 }, { label = 'Blanket 32', hash = 0xC073E2CA },
    { label = 'Blanket 33', hash = 0xEDCB3D78 }, { label = 'Blanket 34', hash = 0xA3D5298D },
    { label = 'Blanket 35', hash = 0xB19B4519 }, { label = 'Blanket 36', hash = 0xCDD2FB96 },
    { label = 'Blanket 37', hash = 0xC097E12C }, { label = 'Blanket 38', hash = 0xD333865B },
    { label = 'Blanket 39', hash = 0xE409A807 }, { label = 'Blanket 40', hash = 0xF6484C84 },
    { label = 'Blanket 41', hash = 0xEC040C89 }, { label = 'Blanket 42', hash = 0x19C5E80C },
    { label = 'Blanket 43', hash = 0x64BE7DF8 }, { label = 'Blanket 44', hash = 0x3278996D },
    { label = 'Blanket 45', hash = 0x003D34F3 }, { label = 'Blanket 46', hash = 0x3BA0D76D },
    { label = 'Blanket 47', hash = 0x4BF1F80F }, { label = 'Blanket 48', hash = 0x5F0F9E4A },
    { label = 'Blanket 49', hash = 0x71DFC3EA }, { label = 'Blanket 50', hash = 0xF506CA32 },
    { label = 'Blanket 51', hash = 0x2A6D33E8 }, { label = 'Blanket 52', hash = 0xFFB1DE72 },
    { label = 'Blanket 53', hash = 0x0DC87A9F }, { label = 'Blanket 54', hash = 0x20D4A0BF },
    { label = 'Blanket 55', hash = 0x127E0412 }, { label = 'Blanket 56', hash = 0xE32A1050 },
    { label = 'Blanket 57', hash = 0x5894FB24 }, { label = 'Blanket 58', hash = 0xD9E17DBB },
    { label = 'Blanket 59', hash = 0xAB302059 }, { label = 'Blanket 60', hash = 0x9E468686 },
    { label = 'Blanket 61', hash = 0x90A31F96 }, { label = 'Blanket 62', hash = 0x9AD633FC },
    { label = 'Blanket 63', hash = 0x53B325B7 }, { label = 'Blanket 64', hash = 0x7D637917 },
    { label = 'Blanket 65', hash = 0xC7688D20 },
}

-- Saddlebags
Config.Saddlebags = {
    { label = 'No Saddlebags', hash = 0 },
    { label = 'Saddlebag 1',  hash = 0x5277E9BA }, { label = 'Saddlebag 2',  hash = 0x20AA8620 },
    { label = 'Saddlebag 3',  hash = 0x577EF434 }, { label = 'Saddlebag 4',  hash = 0x293E17B3 },
    { label = 'Saddlebag 5',  hash = 0xE4108D59 }, { label = 'Saddlebag 6',  hash = 0xC019F804 },
    { label = 'Saddlebag 7',  hash = 0x8BE10F93 }, { label = 'Saddlebag 8',  hash = 0x9D593283 },
    { label = 'Saddlebag 9',  hash = 0xE57042B4 }, { label = 'Saddlebag 10', hash = 0xF8FB69CA },
    { label = 'Saddlebag 11', hash = 0xC05AA4AA }, { label = 'Saddlebag 12', hash = 0xAE110017 },
    { label = 'Saddlebag 13', hash = 0xB4F40DD9 }, { label = 'Saddlebag 14', hash = 0xE2ADE94C },
    { label = 'Saddlebag 15', hash = 0xD048C482 }, { label = 'Saddlebag 16', hash = 0xEEC77E72 },
    { label = 'Saddlebag 17', hash = 0x2AEFF6CA }, { label = 'Saddlebag 18', hash = 0x1D4EDB88 },
    { label = 'Saddlebag 19', hash = 0x0E893DFD }, { label = 'Saddlebag 20', hash = 0xF0C30271 },
}

-- Stirrups
Config.Stirrups = {
    { label = 'No Stirrups', hash = 0 },
    { label = 'Stirrups 1',  hash = 0x587DD49F }, { label = 'Stirrups 2',  hash = 0x67AF7302 },
    { label = 'Stirrups 3',  hash = 0x75178DD2 }, { label = 'Stirrups 4',  hash = 0x8246282F },
    { label = 'Stirrups 5',  hash = 0xCB9A3AD6 }, { label = 'Stirrups 6',  hash = 0x9EE8E174 },
    { label = 'Stirrups 7',  hash = 0xE73FF221 }, { label = 'Stirrups 8',  hash = 0xBDF19F85 },
    { label = 'Stirrups 9',  hash = 0x03B3AB08 }, { label = 'Stirrups 10', hash = 0xD8AE54FE },
    { label = 'Stirrups 11', hash = 0x8D0BC7DA },
}

-- Bedrolls
Config.Bedrolls = {
    { label = 'No Bedroll', hash = 0 },
    { label = 'Bedroll 1',  hash = 0x9FD99D7D }, { label = 'Bedroll 2',  hash = 0x8C9F7709 },
    { label = 'Bedroll 3',  hash = 0x7B55D476 }, { label = 'Bedroll 4',  hash = 0xD8258E14 },
    { label = 'Bedroll 5',  hash = 0x0AC1F34C }, { label = 'Bedroll 6',  hash = 0x18BB6B30 },
    { label = 'Bedroll 7',  hash = 0x12F0DF9F }, { label = 'Bedroll 8',  hash = 0x1B43F045 },
    { label = 'Bedroll 9',  hash = 0x55A0E4FE }, { label = 'Bedroll 10', hash = 0xFFB0391E },
    { label = 'Bedroll 11', hash = 0x084E5AFA }, { label = 'Bedroll 12', hash = 0x9D868568 },
    { label = 'Bedroll 13', hash = 0x72FCB059 }, { label = 'Bedroll 14', hash = 0x69B29DC5 },
    { label = 'Bedroll 15', hash = 0xD258EF10 }, { label = 'Bedroll 16', hash = 0x98214B1C },
    { label = 'Bedroll 17', hash = 0x45FEA6D8 }, { label = 'Bedroll 18', hash = 0xA643680C },
    { label = 'Bedroll 19', hash = 0x7C8A149A }, { label = 'Bedroll 20', hash = 0x8DD7B735 },
    { label = 'Bedroll 21', hash = 0xA1FD8B43 }, { label = 'Bedroll 22', hash = 0xB4532FEE },
    { label = 'Bedroll 23', hash = 0xBC664014 }, { label = 'Bedroll 24', hash = 0xD020E789 },
    { label = 'Bedroll 25', hash = 0x69B21ADD }, { label = 'Bedroll 26', hash = 0x4B7E0712 },
    { label = 'Bedroll 27', hash = 0x36BEDD90 }, { label = 'Bedroll 28', hash = 0x27543EBB },
    { label = 'Bedroll 29', hash = 0x841C784A }, { label = 'Bedroll 30', hash = 0x73D157B4 },
}

-- Manes
Config.Manes = {
    { label = 'Default Mane', hash = 0 },
    { label = 'Mane 1',   hash = 0x0235DBF1 }, { label = 'Mane 2',   hash = 0x0354F6B7 },
    { label = 'Mane 3',   hash = 0x0512377B }, { label = 'Mane 4',   hash = 0x054A3CB0 },
    { label = 'Mane 5',   hash = 0x0632F2B7 }, { label = 'Mane 6',   hash = 0x09836E71 },
    { label = 'Mane 7',   hash = 0x09A640A3 }, { label = 'Mane 8',   hash = 0x0AFB7C24 },
    { label = 'Mane 9',   hash = 0x0B52F0BC }, { label = 'Mane 10',  hash = 0x0DCF5321 },
    { label = 'Mane 11',  hash = 0x130E341A }, { label = 'Mane 12',  hash = 0x14098229 },
    { label = 'Mane 13',  hash = 0x16923E26 }, { label = 'Mane 14',  hash = 0x18199F48 },
    { label = 'Mane 15',  hash = 0x1A5A45B6 }, { label = 'Mane 16',  hash = 0x1DF21752 },
    { label = 'Mane 17',  hash = 0x1FDC6D0F }, { label = 'Mane 18',  hash = 0x241D7FBD },
    { label = 'Mane 19',  hash = 0x25627B98 }, { label = 'Mane 20',  hash = 0x2D47B5FD },
    { label = 'Mane 21',  hash = 0x2E378E8A }, { label = 'Mane 22',  hash = 0x2FCAF0CB },
    { label = 'Mane 23',  hash = 0x388E4B32 }, { label = 'Mane 24',  hash = 0x3A7C2C86 },
    { label = 'Mane 25',  hash = 0x3BFE2A17 }, { label = 'Mane 26',  hash = 0x3F1FEE4C },
    { label = 'Mane 27',  hash = 0x419D9470 }, { label = 'Mane 28',  hash = 0x41EA9196 },
    { label = 'Mane 29',  hash = 0x446A6F01 }, { label = 'Mane 30',  hash = 0x483AC803 },
    { label = 'Mane 31',  hash = 0x4F148D45 }, { label = 'Mane 32',  hash = 0x4FCC51B3 },
    { label = 'Mane 33',  hash = 0x50AC7CC6 }, { label = 'Mane 34',  hash = 0x52DC15C8 },
    { label = 'Mane 35',  hash = 0x5445B9C0 }, { label = 'Mane 36',  hash = 0x5D596CCD },
    { label = 'Mane 37',  hash = 0x5DE62AE8 }, { label = 'Mane 38',  hash = 0x5ED14B9F },
    { label = 'Mane 39',  hash = 0x5F0395A3 }, { label = 'Mane 40',  hash = 0x5FE29755 },
    { label = 'Mane 41',  hash = 0x6038F7FF }, { label = 'Mane 42',  hash = 0x648A3924 },
    { label = 'Mane 43',  hash = 0x66215D77 }, { label = 'Mane 44',  hash = 0x6B3A6471 },
    { label = 'Mane 45',  hash = 0x6CB9310E }, { label = 'Mane 46',  hash = 0x6D9412B5 },
    { label = 'Mane 47',  hash = 0x6F4510C4 }, { label = 'Mane 48',  hash = 0x7098D141 },
    { label = 'Mane 49',  hash = 0x7D902D5A }, { label = 'Mane 50',  hash = 0x817B10F6 },
    { label = 'Mane 51',  hash = 0x83563E39 }, { label = 'Mane 52',  hash = 0x838E5EB8 },
    { label = 'Mane 53',  hash = 0x86457C9A }, { label = 'Mane 54',  hash = 0x8679685F },
    { label = 'Mane 55',  hash = 0x92B2579E }, { label = 'Mane 56',  hash = 0x94F58186 },
    { label = 'Mane 57',  hash = 0x960C1B33 }, { label = 'Mane 58',  hash = 0x96FE6589 },
    { label = 'Mane 59',  hash = 0x97105EF6 }, { label = 'Mane 60',  hash = 0x97D095F4 },
    { label = 'Mane 61',  hash = 0x99F5A3FA }, { label = 'Mane 62',  hash = 0x9DF8175C },
    { label = 'Mane 63',  hash = 0xA0F4F423 }, { label = 'Mane 64',  hash = 0xA193A97A },
    { label = 'Mane 65',  hash = 0xA4E1B8DE }, { label = 'Mane 66',  hash = 0xA64BFD6D },
    { label = 'Mane 67',  hash = 0xA7A4DD49 }, { label = 'Mane 68',  hash = 0xAA3FAC1A },
    { label = 'Mane 69',  hash = 0xABA8475F }, { label = 'Mane 70',  hash = 0xACA2B4B1 },
    { label = 'Mane 71',  hash = 0xB13D134B }, { label = 'Mane 72',  hash = 0xB288D42C },
    { label = 'Mane 73',  hash = 0xB2FB934B }, { label = 'Mane 74',  hash = 0xB5F379E6 },
    { label = 'Mane 75',  hash = 0xB881489D }, { label = 'Mane 76',  hash = 0xBD7B6B05 },
    { label = 'Mane 77',  hash = 0xC0085B74 }, { label = 'Mane 78',  hash = 0xC15371C1 },
    { label = 'Mane 79',  hash = 0xC8646863 }, { label = 'Mane 80',  hash = 0xC929BFA7 },
    { label = 'Mane 81',  hash = 0xC9D16B31 }, { label = 'Mane 82',  hash = 0xCDC9C8E7 },
    { label = 'Mane 83',  hash = 0xCF434F57 }, { label = 'Mane 84',  hash = 0xD152FE09 },
    { label = 'Mane 85',  hash = 0xD43503D5 }, { label = 'Mane 86',  hash = 0xD4E65BE5 },
    { label = 'Mane 87',  hash = 0xD894BF28 }, { label = 'Mane 88',  hash = 0xD9CE8DB4 },
    { label = 'Mane 89',  hash = 0xDC62E996 }, { label = 'Mane 90',  hash = 0xE02377D6 },
    { label = 'Mane 91',  hash = 0xE0BC27A6 }, { label = 'Mane 92',  hash = 0xE12C9C64 },
    { label = 'Mane 93',  hash = 0xE1435081 }, { label = 'Mane 94',  hash = 0xE9FE04D0 },
    { label = 'Mane 95',  hash = 0xEA46E28C }, { label = 'Mane 96',  hash = 0xEAB72F85 },
    { label = 'Mane 97',  hash = 0xF2E555D8 }, { label = 'Mane 98',  hash = 0xF304C014 },
    { label = 'Mane 99',  hash = 0xFC74DF3B }, { label = 'Mane 100', hash = 0xFF020F3A },
    { label = 'Mane 101', hash = 0xFF17AB82 }, { label = 'Mane 102', hash = 0xFFF3B76A },
}

-- Tails
Config.Tails = {
    { label = 'Default Tail', hash = 0 },
    { label = 'Tail 1',  hash = 0x04951F22 }, { label = 'Tail 2',  hash = 0x0607E6DD },
    { label = 'Tail 3',  hash = 0x066C266F }, { label = 'Tail 4',  hash = 0x073073A2 },
    { label = 'Tail 5',  hash = 0x084D6B90 }, { label = 'Tail 6',  hash = 0x0AFB492C },
    { label = 'Tail 7',  hash = 0x12DBBBAF }, { label = 'Tail 8',  hash = 0x17EB79D3 },
    { label = 'Tail 9',  hash = 0x1A3B721B }, { label = 'Tail 10', hash = 0x1BB5EAA1 },
    { label = 'Tail 11', hash = 0x1E9A18C2 }, { label = 'Tail 12', hash = 0x1F7A99EA },
    { label = 'Tail 13', hash = 0x25B51566 }, { label = 'Tail 14', hash = 0x2E753874 },
    { label = 'Tail 15', hash = 0x30603BB5 }, { label = 'Tail 16', hash = 0x33E7B1CB },
    { label = 'Tail 17', hash = 0x383E86F3 }, { label = 'Tail 18', hash = 0x3AE050B5 },
    { label = 'Tail 19', hash = 0x3B27D1DD }, { label = 'Tail 20', hash = 0x3B8A8D0C },
    { label = 'Tail 21', hash = 0x3D1F13D4 }, { label = 'Tail 22', hash = 0x3D212D77 },
    { label = 'Tail 23', hash = 0x4124CC49 }, { label = 'Tail 24', hash = 0x49CD2991 },
    { label = 'Tail 25', hash = 0x4B51B039 }, { label = 'Tail 26', hash = 0x4F5268A4 },
    { label = 'Tail 27', hash = 0x5062FC53 }, { label = 'Tail 28', hash = 0x508AD44A },
    { label = 'Tail 29', hash = 0x543203ED }, { label = 'Tail 30', hash = 0x574BC82D },
    { label = 'Tail 31', hash = 0x5D7FA043 }, { label = 'Tail 32', hash = 0x5F4871C5 },
    { label = 'Tail 33', hash = 0x607956E9 }, { label = 'Tail 34', hash = 0x695B2E3F },
    { label = 'Tail 35', hash = 0x69756C80 }, { label = 'Tail 36', hash = 0x6DB6F164 },
    { label = 'Tail 37', hash = 0x740701A3 }, { label = 'Tail 38', hash = 0x7522834F },
    { label = 'Tail 39', hash = 0x75C4C716 }, { label = 'Tail 40', hash = 0x7A248ABE },
    { label = 'Tail 41', hash = 0x810A5CE0 }, { label = 'Tail 42', hash = 0x82DB38EE },
    { label = 'Tail 43', hash = 0x84269E43 }, { label = 'Tail 44', hash = 0x84ADE4E4 },
    { label = 'Tail 45', hash = 0x876B27E0 }, { label = 'Tail 46', hash = 0x88A2AA53 },
    { label = 'Tail 47', hash = 0x894C290D }, { label = 'Tail 48', hash = 0x96EDC3D1 },
    { label = 'Tail 49', hash = 0x972AC447 }, { label = 'Tail 50', hash = 0x9CB1CFD8 },
    { label = 'Tail 51', hash = 0xA0775A83 }, { label = 'Tail 52', hash = 0xA3DA055A },
    { label = 'Tail 53', hash = 0xA4F0E056 }, { label = 'Tail 54', hash = 0xA62C9657 },
    { label = 'Tail 55', hash = 0xA7438C29 }, { label = 'Tail 56', hash = 0xA8A4673A },
    { label = 'Tail 57', hash = 0xB244FE1E }, { label = 'Tail 58', hash = 0xB4374DB1 },
    { label = 'Tail 59', hash = 0xB4AB3354 }, { label = 'Tail 60', hash = 0xBCD412B1 },
    { label = 'Tail 61', hash = 0xC0AF3489 }, { label = 'Tail 62', hash = 0xC2FA4FF2 },
    { label = 'Tail 63', hash = 0xC304EB4C }, { label = 'Tail 64', hash = 0xC74FCC45 },
    { label = 'Tail 65', hash = 0xCDFF359A }, { label = 'Tail 66', hash = 0xCE62B5CE },
    { label = 'Tail 67', hash = 0xD143E02D }, { label = 'Tail 68', hash = 0xD7D68A7B },
    { label = 'Tail 69', hash = 0xD9288D47 }, { label = 'Tail 70', hash = 0xD9EA1916 },
    { label = 'Tail 71', hash = 0xDCE41557 }, { label = 'Tail 72', hash = 0xDD9F5447 },
    { label = 'Tail 73', hash = 0xDDB48566 }, { label = 'Tail 74', hash = 0xE38F5D96 },
    { label = 'Tail 75', hash = 0xEAA5EEE7 }, { label = 'Tail 76', hash = 0xEABBBAB9 },
    { label = 'Tail 77', hash = 0xEAEAB164 }, { label = 'Tail 78', hash = 0xEBC7218B },
    { label = 'Tail 79', hash = 0xED0397AC }, { label = 'Tail 80', hash = 0xED787168 },
    { label = 'Tail 81', hash = 0xEFA67855 }, { label = 'Tail 82', hash = 0xF4294320 },
    { label = 'Tail 83', hash = 0xF4A3443C }, { label = 'Tail 84', hash = 0xF6B0AB06 },
    { label = 'Tail 85', hash = 0xF867D611 },
}

-- Horns
Config.Horns = {
    { label = 'No Horn',  hash = 0 },
    { label = 'Horn 1',   hash = 0xC6C381F5 }, { label = 'Horn 2',   hash = 0xDBE6AC3B },
    { label = 'Horn 3',   hash = 0x2A28C8BE }, { label = 'Horn 4',   hash = 0xE1DC3856 },
    { label = 'Horn 5',   hash = 0x34135CC3 }, { label = 'Horn 6',   hash = 0x3E40711D },
    { label = 'Horn 7',   hash = 0x107D9598 }, { label = 'Horn 8',   hash = 0x9AD2AA40 },
    { label = 'Horn 9',   hash = 0xED0BCEB5 }, { label = 'Horn 10',  hash = 0xF826E4EB },
    { label = 'Horn 11',  hash = 0xF8CAE723 }, { label = 'Horn 12',  hash = 0xE1B1B8F1 },
    { label = 'Horn 13',  hash = 0x333CDC06 }, { label = 'Horn 14',  hash = 0xF09C56EE },
}

-- Masks
Config.Masks = {
    { label = 'No Mask',  hash = 0 },
    { label = 'Mask 1',   hash = 0x08A78F53 }, { label = 'Mask 2',   hash = 0x13AC6E51 },
    { label = 'Mask 3',   hash = 0x226B2F76 }, { label = 'Mask 4',   hash = 0x30044BAC },
    { label = 'Mask 5',   hash = 0x406FC6C7 }, { label = 'Mask 6',   hash = 0x4C8C83A4 },
    { label = 'Mask 7',   hash = 0x4E22622C }, { label = 'Mask 8',   hash = 0x53EEEBD4 },
    { label = 'Mask 9',   hash = 0x61BEAE08 }, { label = 'Mask 10',  hash = 0x68FB97DE },
    { label = 'Mask 11',  hash = 0x69CD996E }, { label = 'Mask 12',  hash = 0x6B355791 },
    { label = 'Mask 13',  hash = 0x702A4AF3 }, { label = 'Mask 14',  hash = 0x7A773AC1 },
    { label = 'Mask 15',  hash = 0x7BFA791B }, { label = 'Mask 16',  hash = 0x872A0C5A },
    { label = 'Mask 17',  hash = 0x8C471684 }, { label = 'Mask 18',  hash = 0x8DB38601 },
    { label = 'Mask 19',  hash = 0x8DCC1CBE }, { label = 'Mask 20',  hash = 0x90A62272 },
    { label = 'Mask 21',  hash = 0x9946F874 }, { label = 'Mask 22',  hash = 0x9A11B219 },
    { label = 'Mask 23',  hash = 0x9DB125FC }, { label = 'Mask 24',  hash = 0xA45049C6 },
    { label = 'Mask 25',  hash = 0xB0395F88 }, { label = 'Mask 26',  hash = 0xB395D1C5 },
    { label = 'Mask 27',  hash = 0xB567EBF5 }, { label = 'Mask 28',  hash = 0xBD887906 },
    { label = 'Mask 29',  hash = 0xC4886BDC }, { label = 'Mask 30',  hash = 0xC70D8F40 },
    { label = 'Mask 31',  hash = 0xC907FCA9 }, { label = 'Mask 32',  hash = 0xD6E279B1 },
    { label = 'Mask 33',  hash = 0xDDCDB9A0 }, { label = 'Mask 34',  hash = 0xE3278C28 },
    { label = 'Mask 35',  hash = 0xEC10D626 }, { label = 'Mask 36',  hash = 0xEEF65F11 },
    { label = 'Mask 37',  hash = 0xF606EC4A }, { label = 'Mask 38',  hash = 0xFA5B72BB },
    { label = 'Mask 39',  hash = 0xD70C73EA }, { label = 'Mask 40',  hash = 0xF17728C7 },
    { label = 'Mask 41',  hash = 0x68DB4FAD }, { label = 'Mask 42',  hash = 0x62C5B02A },
    { label = 'Mask 43',  hash = 0xF0ED62FF }, { label = 'Mask 44',  hash = 0x2E776EE6 },
    { label = 'Mask 45',  hash = 0x75637CBD }, { label = 'Mask 46',  hash = 0x4A992729 },
    { label = 'Mask 47',  hash = 0x4E312E61 }, { label = 'Mask 48',  hash = 0x48099436 },
    { label = 'Mask 49',  hash = 0x77987353 }, { label = 'Mask 50',  hash = 0xAD6DDEFD },
    { label = 'Mask 51',  hash = 0x5B22BA68 },
}

-- Mustaches
Config.Mustaches = {
    { label = 'No Mustache', hash = 0 },
    { label = 'Mustache 1',  hash = 0x004BBEED }, { label = 'Mustache 2',  hash = 0x0960D117 },
    { label = 'Mustache 3',  hash = 0x281A6D81 }, { label = 'Mustache 4',  hash = 0x334F83D3 },
    { label = 'Mustache 5',  hash = 0x5497E784 }, { label = 'Mustache 6',  hash = 0x67590D8F },
    { label = 'Mustache 7',  hash = 0x91887491 }, { label = 'Mustache 8',  hash = 0x9ADAF492 },
    { label = 'Mustache 9',  hash = 0xAC459767 }, { label = 'Mustache 10', hash = 0xAF2A2FD8 },
    { label = 'Mustache 11', hash = 0xB755402E }, { label = 'Mustache 12', hash = 0xCFBA5E50 },
    { label = 'Mustache 13', hash = 0xDC895660 }, { label = 'Mustache 14', hash = 0xEAEEF32B },
    { label = 'Mustache 15', hash = 0xED8D1970 }, { label = 'Mustache 16', hash = 0xF7203FC3 },
}

-- ============================================================================
-- WAGONS / CARTS
-- ============================================================================
Config.Wagons = {
    { label = 'Open Top Buggy',      model = 'wagon02x' },
    { label = 'Mail Coach',          model = 'mailcoach' },
    { label = 'Stagecoach (Worn)',   model = 'stagecoach05x' },
    { label = 'Stagecoach (Std)',    model = 'stagecoach02x' },
    { label = 'Buckboard',           model = 'buckboard01x' },
    { label = 'Cart (Wood)',         model = 'cart01' },
    { label = 'Cart (Standard)',     model = 'cart02' },
    { label = 'Cart (Heavy)',        model = 'cart03' },
    { label = 'Wagon (Old)',         model = 'wagon04x' },
    { label = 'Wagon (Box)',         model = 'wagon05x' },
    { label = 'Hungarian Halfbred',  model = 'wagontravel01x' },
    { label = 'Prison Wagon',        model = 'wagonprison01x' },
    { label = 'Outlaw Wagon',        model = 'wagonarmored01x' },
    { label = 'Oil Wagon',           model = 'wagonoil01x' },
    { label = 'Hay Wagon',           model = 'hay_wagon01x' },
    { label = 'Lumber Wagon',        model = 'wagon_lumber01x' },
    { label = 'Sad Train Wagon',     model = 'wagonsadtrain01x' },
}

-- Wagon component slots
Config.WagonComponents = {
    {
        slot = 'frontBox',
        label = 'Front Box',
        bone  = 'BONETAG_FRONTBOX_PROP',
        options = {
            { label = 'None',         model = nil },
            { label = 'Wooden Crate', model = 'p_crate03x' },
            { label = 'Barrel',       model = 'p_barrel03x' },
            { label = 'Hay Bale',     model = 'p_haybale02x' },
            { label = 'Sack',         model = 'p_sackgrain01x' },
            { label = 'Lantern',      model = 'p_lantern03x' },
        },
    },
    {
        slot = 'rearBox',
        label = 'Rear Box',
        bone  = 'BONETAG_REARBOX_PROP',
        options = {
            { label = 'None',         model = nil },
            { label = 'Wooden Crate', model = 'p_crate03x' },
            { label = 'Barrel',       model = 'p_barrel03x' },
            { label = 'Hay Bale',     model = 'p_haybale02x' },
            { label = 'Sack',         model = 'p_sackgrain01x' },
            { label = 'Coffin',       model = 'p_coffin01x' },
        },
    },
    {
        slot = 'sideBoxL',
        label = 'Left Side',
        bone  = 'BONETAG_SIDEBOX_PROP_L',
        options = {
            { label = 'None',    model = nil },
            { label = 'Lantern', model = 'p_lantern03x' },
            { label = 'Toolbox', model = 'p_toolbox01x' },
        },
    },
    {
        slot = 'sideBoxR',
        label = 'Right Side',
        bone  = 'BONETAG_SIDEBOX_PROP_R',
        options = {
            { label = 'None',    model = nil },
            { label = 'Lantern', model = 'p_lantern03x' },
            { label = 'Toolbox', model = 'p_toolbox01x' },
        },
    },
}

-- ============================================================================
-- WEATHER (used by DB-Admin's NUI controls)
-- ============================================================================
Config.WeatherTransition = 15.0

Config.WeatherPresets = {
    { value = 'sunny',          label = 'Sunny',          snow = false, icon = '☀️' },
    { value = 'clear',          label = 'Clear',          snow = false, icon = '🌤️' },
    { value = 'clouds',         label = 'Cloudy',         snow = false, icon = '☁️' },
    { value = 'overcast',       label = 'Overcast',       snow = false, icon = '🌥️' },
    { value = 'rain',           label = 'Rain',           snow = false, icon = '🌧️' },
    { value = 'thunderstorm',   label = 'Thunderstorm',   snow = false, icon = '⛈️' },
    { value = 'hurricane',      label = 'Hurricane',      snow = false, icon = '🌀' },
    { value = 'drizzle',        label = 'Drizzle',        snow = false, icon = '🌦️' },
    { value = 'shower',         label = 'Shower',         snow = false, icon = '💧' },
    { value = 'fog',            label = 'Fog',            snow = false, icon = '🌫️' },
    { value = 'misty',          label = 'Misty',          snow = false, icon = '🌫️' },
    { value = 'sandstorm',      label = 'Sandstorm',      snow = false, icon = '🌪️' },
    { value = 'snow',           label = 'Snow',           snow = true,  icon = '❄️' },
    { value = 'snowlight',      label = 'Light Snow',     snow = true,  icon = '🌨️' },
    { value = 'blizzard',       label = 'Blizzard',       snow = true,  icon = '🥶' },
    { value = 'groundblizzard', label = 'Ground Blizzard', snow = true, icon = '🌨️' },
    { value = 'whiteout',       label = 'Whiteout',       snow = true,  icon = '⚪' },
}

-- ============================================================================
-- DEVELOPER TOOLS
-- ============================================================================
Config.CoordFormats = {
    { label = 'Vector1 (X)',         key = 'vector1' },
    { label = 'Vector2 (X, Y)',      key = 'vector2' },
    { label = 'Vector3 (X, Y, Z)',   key = 'vector3' },
    { label = 'Vector4 (X, Y, Z, H)', key = 'vector4' },
    { label = 'Heading',             key = 'heading' },
}

Config.CommonAnimals = {
    -- Predators
    { label = 'Wolf',                hash = 'a_c_wolf' },
    { label = 'Grizzly Bear',        hash = 'a_c_bear_01' },
    { label = 'Cougar',              hash = 'a_c_cougar_01' },
    { label = 'Coyote',              hash = 'a_c_coyote_01' },
    { label = 'Panther',             hash = 'a_c_panther_01' },
    { label = 'Alligator',           hash = 'a_c_alligator_01' },
    
    -- Big Game
    { label = 'Bison',               hash = 'a_c_buffalo_01' },
    { label = 'Bull',                hash = 'a_c_bull_01' },
    { label = 'Cow',                 hash = 'a_c_cow' },
    { label = 'White Tail Deer',     hash = 'a_c_deer_01' },
    { label = 'Elk',                 hash = 'a_c_elk_01' },
    { label = 'Moose',               hash = 'a_c_moose_01' },
    { label = 'Boar',                hash = 'a_c_boar_01' },
    
    -- Small Animals
    { label = 'Rabbit',              hash = 'a_c_rabbit_01' },
    { label = 'Beaver',              hash = 'a_c_beaver_01' },
    { label = 'Raccoon',             hash = 'a_c_raccoon_01' },
    { label = 'Skunk',               hash = 'a_c_skunk_01' },
    { label = 'Armadillo',           hash = 'a_c_armadillo_01' },
    
    -- Birds
    { label = 'Eagle',               hash = 'a_c_eagle_01' },
    { label = 'Hawk',                hash = 'a_c_hawk_01' },
    { label = 'Owl',                 hash = 'a_c_owl_01' },
    { label = 'Vulture',             hash = 'a_c_vulture_01' },
    { label = 'Chicken',             hash = 'a_c_chicken_01' },
    { label = 'Rooster',             hash = 'a_c_rooster_01' },
    
    -- Domestic
    { label = 'Pig',                 hash = 'a_c_pig_01' },
    { label = 'Sheep',               hash = 'a_c_sheep_01' },
    { label = 'Goat',                hash = 'a_c_goat_01' },
    { label = 'Dog (Hound)',         hash = 'a_c_dogamericanfoxhound_01' },
    { label = 'Dog (Husky)',         hash = 'a_c_dogamericanhusky_01' },
    { label = 'Cat',                 hash = 'a_c_cat_01' },
}

-- ============================================================================
-- DOOR HASHES (dev overlay)
-- ============================================================================
Config.DoorHashes = {
    [123675751]  = { 123675751, 603318791, 'p_door_photo02x', 2735.529, -1115.709, 48.100 },
    [804086151]  = { 804086151, -705727376, 'p_doornbd31x', 2629.295, -1220.293, 52.398 },
    [841127028]  = { 841127028, 831542679, 's_doorsldprtn01x', 2710.566, -1291.204, 48.632 },
    [1057071735] = { 1057071735, 367033685, 'p_doornbd39x', 2719.884, -1281.542, 48.638 },
    [1069752686] = { 1069752686, 2086973760, 'p_door_nbx_art01x_l', 2692.400, -1195.899, 55.467 },
    [1077640496] = { 1077640496, -1847829453, 'p_door_nbx_art01x_r', 2702.091, -1194.319, 55.095 },
    [1079875175] = { 1079875175, -1728773655, 'p_door_photo02x_l', 2734.152, -1115.709, 48.100 },
    [1180868565] = { 1180868565, -766448386, 'p_door_nbx_gamble01x', 2711.437, -1293.084, 59.458 },
}

-- ============================================================================
-- TROLL
-- ============================================================================
Config.Troll = {
    WildAttack = {
        Animals  = { 'a_c_wolf', 'a_c_bear_01', 'a_c_cougar_01' },
        Count    = 3,
        Distance = 15.0,
    },
    FireDuration = 10000,
}

-- ============================================================================
-- ANNOUNCEMENTS
-- ============================================================================
Config.Announcements = {
    -- Discord webhook for announcement logging
    Webhook = '', -- leave empty to disable

    -- Display duration on screen (ms)
    Duration = 8000,

    -- Predefined announcement templates (quick send)
    Templates = {
        { label = 'Server Restart - 5 Minutes', message = 'Server will restart in 5 minutes. Please find a safe location.' },
        { label = 'Server Restart - 1 Minute',  message = 'Server restarting in 1 minute! Disconnect to avoid issues.' },
        { label = 'Event Starting Soon',        message = 'A server event is starting soon! Check Discord for details.' },
        { label = 'Maintenance Notice',         message = 'Brief maintenance incoming. Expect short downtime.' },
        { label = 'Welcome New Players',        message = 'Welcome to the server! Read the rules and have fun!' },
    },

    -- Announcement types (color-coded)
    Types = {
        { value = 'info',    label = 'Info',    color = { r = 50,  g = 150, b = 255 } },
        { value = 'warning', label = 'Warning', color = { r = 255, g = 200, b = 0 } },
        { value = 'alert',   label = 'Alert',   color = { r = 255, g = 50,  b = 50 } },
        { value = 'success', label = 'Success', color = { r = 50,  g = 200, b = 50 } },
    },
}

-- ============================================================================
-- PERMISSIONS UI
-- ============================================================================
Config.PermissionGroups = {
    -- Groups available to assign in-game (must match server.cfg group names)
    { value = 'admin',     label = 'Admin'     },
    { value = 'moderator', label = 'Moderator' },
    { value = 'developer', label = 'Developer' },
    { value = 'support',   label = 'Support'   },
}

-- Available individual permissions to grant
Config.AvailablePermissions = {
    { value = 'dbadmin.admin',     label = 'DB-Admin: Full Admin'  },
    { value = 'dbadmin.moderator', label = 'DB-Admin: Moderator'   },
    { value = 'dbadmin.developer', label = 'DB-Admin: Developer'   },
    { value = 'dbadmin.troll',     label = 'DB-Admin: Troll'       },
    { value = 'dbadmin.reports',   label = 'DB-Admin: Reports'     },
    { value = 'dbadmin.finances',  label = 'DB-Admin: Finances'    },
}