--[[
  ___  _      __                     _           _   _           
 / _ \| |__  / _|_   _ ___  ___ __ _| |_ ___  __| | | |__  _   _ 
| | | | '_ \| |_| | | / __|/ __/ _` | __/ _ \/ _` | | '_ \| | | |
| |_| | |_) |  _| |_| \__ \ (_| (_| | ||  __/ (_| | | |_) | |_| |
 \___/|_.__/|_|  \__,_|___/\___\__,_|\__\___|\__,_| |_.__/ \__, |
 ____  _       _            _    ____ ____                 |___/ 
|  _ \(_) ___ | |_ _ __ ___| | _| ___/ ___|                      
| |_) | |/ _ \| __| '__/ _ \ |/ /___ \___ \                      
|  __/| | (_) | |_| | |  __/   < ___) |__) |                     
|_|   |_|\___/ \__|_|  \___|_|\_\____/____/                      

]]--

bit32 = {};
local N = 32;
local P = 2 ^ N;
bit32.bnot = function(x)
	x = x % P;
	return (P - 1) - x;
end;
bit32.band = function(x, y)
	if (y == 255) then
		return x % 256;
	end
	if (y == 65535) then
		return x % 65536;
	end
	if (y == 4294967295) then
		return x % 4294967296;
	end
	x, y = x % P, y % P;
	local r = 0;
	local p = 1;
	for i = 1, N do
		local a, b = x % 2, y % 2;
		x, y = math.floor(x / 2), math.floor(y / 2);
		if ((a + b) == 2) then
			r = r + p;
		end
		p = 2 * p;
	end
	return r;
end;
bit32.bor = function(x, y)
	if (y == 255) then
		return (x - (x % 256)) + 255;
	end
	if (y == 65535) then
		return (x - (x % 65536)) + 65535;
	end
	if (y == 4294967295) then
		return 4294967295;
	end
	x, y = x % P, y % P;
	local r = 0;
	local p = 1;
	for i = 1, N do
		local a, b = x % 2, y % 2;
		x, y = math.floor(x / 2), math.floor(y / 2);
		if ((a + b) >= 1) then
			r = r + p;
		end
		p = 2 * p;
	end
	return r;
end;
bit32.bxor = function(x, y)
	x, y = x % P, y % P;
	local r = 0;
	local p = 1;
	for i = 1, N do
		local a, b = x % 2, y % 2;
		x, y = math.floor(x / 2), math.floor(y / 2);
		if ((a + b) == 1) then
			r = r + p;
		end
		p = 2 * p;
	end
	return r;
end;
bit32.lshift = function(x, s_amount)
	if (math.abs(s_amount) >= N) then
		return 0;
	end
	x = x % P;
	if (s_amount < 0) then
		return math.floor(x * (2 ^ s_amount));
	else
		return (x * (2 ^ s_amount)) % P;
	end
end;
bit32.rshift = function(x, s_amount)
	if (math.abs(s_amount) >= N) then
		return 0;
	end
	x = x % P;
	if (s_amount > 0) then
		return math.floor(x * (2 ^ -s_amount));
	else
		return (x * (2 ^ -s_amount)) % P;
	end
end;
bit32.arshift = function(x, s_amount)
	if (math.abs(s_amount) >= N) then
		return 0;
	end
	x = x % P;
	if (s_amount > 0) then
		local add = 0;
		if (x >= (P / 2)) then
			add = P - (2 ^ (N - s_amount));
		end
		return math.floor(x * (2 ^ -s_amount)) + add;
	else
		return (x * (2 ^ -s_amount)) % P;
	end
end;
local TABLE_TableIndirection = {};
TABLE_TableIndirection["StrToNumber%0"] = tonumber;
TABLE_TableIndirection["Byte%0"] = string['byte'];
TABLE_TableIndirection["Char%0"] = string['char'];
TABLE_TableIndirection["Sub%0"] = string['sub'];
TABLE_TableIndirection["Subg%0"] = string['gsub'];
TABLE_TableIndirection["Rep%0"] = string['rep'];
TABLE_TableIndirection["Concat%0"] = table['concat'];
TABLE_TableIndirection["Insert%0"] = table['insert'];
TABLE_TableIndirection["LDExp%0"] = math['ldexp'];
TABLE_TableIndirection["GetFEnv%0"] = getfenv or function()
	return _ENV;
end;
TABLE_TableIndirection["Setmetatable%0"] = setmetatable;
TABLE_TableIndirection["PCall%0"] = pcall;
TABLE_TableIndirection["Select%0"] = select;
TABLE_TableIndirection["Unpack%0"] = unpack or table['unpack'];
TABLE_TableIndirection["ToNumber%0"] = tonumber;
local function VMCall(ByteString, vmenv, ...)
	TABLE_TableIndirection["DIP%0"] = 1;
	TABLE_TableIndirection["repeatNext%0"] = nil;
	ByteString = TABLE_TableIndirection["Subg%0"](TABLE_TableIndirection["Sub%0"](ByteString, 5), "..", function(byte)
		if ((TABLE_TableIndirection["Byte%0"](byte, 5 - 3) == (226 - 147)) or (4593 <= 2672)) then
			TABLE_TableIndirection["FlatIdent_25DF3%0"] = 0;
			while true do
				if (TABLE_TableIndirection["FlatIdent_25DF3%0"] ~= 0) then
				else
					TABLE_TableIndirection["repeatNext%0"] = TABLE_TableIndirection["StrToNumber%0"](TABLE_TableIndirection["Sub%0"](byte, 1 - 0, 2 - 1));
					return "";
				end
			end
		else
			TABLE_TableIndirection["FlatIdent_5BA5E%0"] = 0;
			TABLE_TableIndirection["a%0"] = nil;
			while true do
				if ((TABLE_TableIndirection["FlatIdent_5BA5E%0"] ~= 0) or (1168 > 3156)) then
				else
					TABLE_TableIndirection["a%0"] = TABLE_TableIndirection["Char%0"](TABLE_TableIndirection["StrToNumber%0"](byte, 16));
					if (TABLE_TableIndirection["repeatNext%0"] or (572 > 4486)) then
						TABLE_TableIndirection["b%0"] = TABLE_TableIndirection["Rep%0"](TABLE_TableIndirection["a%0"], TABLE_TableIndirection["repeatNext%0"]);
						TABLE_TableIndirection["repeatNext%0"] = nil;
						return TABLE_TableIndirection["b%0"];
					else
						return TABLE_TableIndirection["a%0"];
					end
					break;
				end
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if ((1404 == 1404) and End) then
			TABLE_TableIndirection["Res%0"] = (Bit / (2 ^ (Start - 1))) % ((621 - (555 + 64)) ^ (((End - 1) - (Start - (932 - (857 + 74)))) + 1));
			return TABLE_TableIndirection["Res%0"] - (TABLE_TableIndirection["Res%0"] % (569 - (367 + 201)));
		else
			TABLE_TableIndirection["Plc%0"] = (929 - (214 + 713)) ^ (Start - 1);
			return (((Bit % (TABLE_TableIndirection["Plc%0"] + TABLE_TableIndirection["Plc%0"])) >= TABLE_TableIndirection["Plc%0"]) and (1 + 0)) or 0;
		end
	end
	local function gBits8()
		TABLE_TableIndirection["FlatIdent_74348%0"] = 0;
		TABLE_TableIndirection["a%0"] = nil;
		while true do
			if ((TABLE_TableIndirection["FlatIdent_74348%0"] ~= 1) or (3748 < 2212)) then
			else
				return TABLE_TableIndirection["a%0"];
			end
			if (TABLE_TableIndirection["FlatIdent_74348%0"] == 0) then
				TABLE_TableIndirection["a%0"] = TABLE_TableIndirection["Byte%0"](ByteString, TABLE_TableIndirection["DIP%0"], TABLE_TableIndirection["DIP%0"]);
				TABLE_TableIndirection["DIP%0"] = TABLE_TableIndirection["DIP%0"] + 1 + 0;
				TABLE_TableIndirection["FlatIdent_74348%0"] = 1;
			end
		end
	end
	local function gBits16()
		TABLE_TableIndirection["FlatIdent_24A02%0"] = 0;
		TABLE_TableIndirection["a%0"] = nil;
		TABLE_TableIndirection["b%0"] = nil;
		while true do
			if (TABLE_TableIndirection["FlatIdent_24A02%0"] ~= 1) then
			else
				return (TABLE_TableIndirection["b%0"] * 256) + TABLE_TableIndirection["a%0"];
			end
			if ((TABLE_TableIndirection["FlatIdent_24A02%0"] ~= 0) or (1180 == 2180)) then
			else
				TABLE_TableIndirection["a%0"], TABLE_TableIndirection["b%0"] = TABLE_TableIndirection["Byte%0"](ByteString, TABLE_TableIndirection["DIP%0"], TABLE_TableIndirection["DIP%0"] + 2);
				TABLE_TableIndirection["DIP%0"] = TABLE_TableIndirection["DIP%0"] + (879 - (282 + 595));
				TABLE_TableIndirection["FlatIdent_24A02%0"] = 1;
			end
		end
	end
	local function gBits32()
		TABLE_TableIndirection["FlatIdent_89ECE%0"] = 0;
		TABLE_TableIndirection["a%0"] = nil;
		TABLE_TableIndirection["b%0"] = nil;
		TABLE_TableIndirection["c%0"] = nil;
		TABLE_TableIndirection["d%0"] = nil;
		while true do
			if (TABLE_TableIndirection["FlatIdent_89ECE%0"] == 1) then
				return (TABLE_TableIndirection["d%0"] * (15077001 + 1700215)) + (TABLE_TableIndirection["c%0"] * (93426 - 27890)) + (TABLE_TableIndirection["b%0"] * 256) + TABLE_TableIndirection["a%0"];
			end
			if ((4090 < 4653) and (TABLE_TableIndirection["FlatIdent_89ECE%0"] ~= 0)) then
			else
				TABLE_TableIndirection["a%0"], TABLE_TableIndirection["b%0"], TABLE_TableIndirection["c%0"], TABLE_TableIndirection["d%0"] = TABLE_TableIndirection["Byte%0"](ByteString, TABLE_TableIndirection["DIP%0"], TABLE_TableIndirection["DIP%0"] + (1640 - (1523 + 114)));
				TABLE_TableIndirection["DIP%0"] = TABLE_TableIndirection["DIP%0"] + 4;
				TABLE_TableIndirection["FlatIdent_89ECE%0"] = 1;
			end
		end
	end
	local function gFloat()
		TABLE_TableIndirection["FlatIdent_52551%0"] = 0;
		TABLE_TableIndirection["Left%0"] = nil;
		TABLE_TableIndirection["Right%0"] = nil;
		TABLE_TableIndirection["IsNormal%0"] = nil;
		TABLE_TableIndirection["Mantissa%0"] = nil;
		TABLE_TableIndirection["Exponent%0"] = nil;
		TABLE_TableIndirection["Sign%0"] = nil;
		while true do
			if ((TABLE_TableIndirection["FlatIdent_52551%0"] ~= 1) or (2652 < 196)) then
			else
				TABLE_TableIndirection["IsNormal%0"] = 1066 - (68 + 997);
				TABLE_TableIndirection["Mantissa%0"] = (gBit(TABLE_TableIndirection["Right%0"], 1, 20) * ((1272 - (226 + 1044)) ^ (139 - 107))) + TABLE_TableIndirection["Left%0"];
				TABLE_TableIndirection["FlatIdent_52551%0"] = 2;
			end
			if (TABLE_TableIndirection["FlatIdent_52551%0"] ~= 0) then
			else
				TABLE_TableIndirection["Left%0"] = gBits32();
				TABLE_TableIndirection["Right%0"] = gBits32();
				TABLE_TableIndirection["FlatIdent_52551%0"] = 1;
			end
			if ((4135 < 4817) and (TABLE_TableIndirection["FlatIdent_52551%0"] ~= 2)) then
			else
				TABLE_TableIndirection["Exponent%0"] = gBit(TABLE_TableIndirection["Right%0"], 21, 148 - (32 + 85));
				TABLE_TableIndirection["Sign%0"] = ((gBit(TABLE_TableIndirection["Right%0"], 32 + 0) == (1 + 0)) and -(958 - (892 + 65))) or 1;
				TABLE_TableIndirection["FlatIdent_52551%0"] = 3;
			end
			if (TABLE_TableIndirection["FlatIdent_52551%0"] ~= 3) then
			else
				if (TABLE_TableIndirection["Exponent%0"] == 0) then
					if (TABLE_TableIndirection["Mantissa%0"] == 0) then
						return TABLE_TableIndirection["Sign%0"] * 0;
					else
						TABLE_TableIndirection["FlatIdent_8B523%0"] = 0;
						while true do
							if (TABLE_TableIndirection["FlatIdent_8B523%0"] ~= 0) then
							else
								TABLE_TableIndirection["Exponent%0"] = 1;
								TABLE_TableIndirection["IsNormal%0"] = 0;
								break;
							end
						end
					end
				elseif (TABLE_TableIndirection["Exponent%0"] ~= 2047) then
				else
					return ((TABLE_TableIndirection["Mantissa%0"] == 0) and (TABLE_TableIndirection["Sign%0"] * (1 / 0))) or (TABLE_TableIndirection["Sign%0"] * NaN);
				end
				return TABLE_TableIndirection["LDExp%0"](TABLE_TableIndirection["Sign%0"], TABLE_TableIndirection["Exponent%0"] - 1023) * (TABLE_TableIndirection["IsNormal%0"] + (TABLE_TableIndirection["Mantissa%0"] / ((4 - 2) ^ (95 - 43))));
			end
		end
	end
	local function gString(Len)
		TABLE_TableIndirection["Str%0"] = nil;
		if not Len then
			TABLE_TableIndirection["FlatIdent_1743D%0"] = 0;
			while true do
				if ((272 == 272) and (TABLE_TableIndirection["FlatIdent_1743D%0"] ~= 0)) then
				else
					Len = gBits32();
					if (Len ~= (0 - 0)) then
					else
						return "";
					end
					break;
				end
			end
		end
		Str = TABLE_TableIndirection["Sub%0"](ByteString, TABLE_TableIndirection["DIP%0"], (TABLE_TableIndirection["DIP%0"] + Len) - 1);
		TABLE_TableIndirection["DIP%0"] = TABLE_TableIndirection["DIP%0"] + Len;
		TABLE_TableIndirection["FStr%0"] = {};
		for Idx = 351 - (87 + 263), #Str do
			TABLE_TableIndirection["FStr%0"][Idx] = TABLE_TableIndirection["Char%0"](TABLE_TableIndirection["Byte%0"](TABLE_TableIndirection["Sub%0"](Str, Idx, Idx)));
		end
		return TABLE_TableIndirection["Concat%0"](TABLE_TableIndirection["FStr%0"]);
	end
	TABLE_TableIndirection["gInt%0"] = gBits32;
	local function _R(...)
		return {...}, TABLE_TableIndirection["Select%0"]("#", ...);
	end
	local function Deserialize()
		TABLE_TableIndirection["Instrs%0"] = {};
		TABLE_TableIndirection["Functions%0"] = {};
		TABLE_TableIndirection["Lines%0"] = {};
		TABLE_TableIndirection["Chunk%0"] = {TABLE_TableIndirection["Instrs%0"],TABLE_TableIndirection["Functions%0"],nil,TABLE_TableIndirection["Lines%0"]};
		TABLE_TableIndirection["ConstCount%0"] = gBits32();
		TABLE_TableIndirection["Consts%0"] = {};
		for Idx = 1, TABLE_TableIndirection["ConstCount%0"] do
			TABLE_TableIndirection["FlatIdent_7366E%0"] = 0;
			TABLE_TableIndirection["Type%0"] = nil;
			TABLE_TableIndirection["Cons%0"] = nil;
			while true do
				if (TABLE_TableIndirection["FlatIdent_7366E%0"] ~= 1) then
				else
					if ((100 <= 3123) and (TABLE_TableIndirection["Type%0"] == 1)) then
						TABLE_TableIndirection["Cons%0"] = gBits8() ~= (0 + 0);
					elseif (TABLE_TableIndirection["Type%0"] == 2) then
						TABLE_TableIndirection["Cons%0"] = gFloat();
					elseif (TABLE_TableIndirection["Type%0"] ~= 3) then
					else
						TABLE_TableIndirection["Cons%0"] = gString();
					end
					TABLE_TableIndirection["Consts%0"][Idx] = TABLE_TableIndirection["Cons%0"];
					break;
				end
				if (0 ~= TABLE_TableIndirection["FlatIdent_7366E%0"]) then
				else
					TABLE_TableIndirection["Type%0"] = gBits8();
					TABLE_TableIndirection["Cons%0"] = nil;
					TABLE_TableIndirection["FlatIdent_7366E%0"] = 1;
				end
			end
		end
		TABLE_TableIndirection["Chunk%0"][7 - 4] = gBits8();
		for Idx = 1 + 0, gBits32() do
			TABLE_TableIndirection["Descriptor%0"] = gBits8();
			if (gBit(TABLE_TableIndirection["Descriptor%0"], 3 - 2, 953 - (802 + 150)) ~= 0) then
			else
				TABLE_TableIndirection["FlatIdent_2F37F%0"] = 0;
				TABLE_TableIndirection["Type%0"] = nil;
				TABLE_TableIndirection["Mask%0"] = nil;
				TABLE_TableIndirection["Inst%0"] = nil;
				while true do
					if ((TABLE_TableIndirection["FlatIdent_2F37F%0"] ~= 2) or (1369 > 4987)) then
					else
						if (gBit(TABLE_TableIndirection["Mask%0"], 443 - (416 + 26), 1) ~= (3 - 2)) then
						else
							TABLE_TableIndirection["Inst%0"][1 + 1] = TABLE_TableIndirection["Consts%0"][TABLE_TableIndirection["Inst%0"][3 - 1]];
						end
						if ((gBit(TABLE_TableIndirection["Mask%0"], 440 - (145 + 293), 2) ~= (431 - (44 + 386))) or (863 >= 4584)) then
						else
							TABLE_TableIndirection["Inst%0"][3] = TABLE_TableIndirection["Consts%0"][TABLE_TableIndirection["Inst%0"][1489 - (998 + 488)]];
						end
						TABLE_TableIndirection["FlatIdent_2F37F%0"] = 3;
					end
					if ((TABLE_TableIndirection["FlatIdent_2F37F%0"] ~= 0) or (724 >= 1668)) then
					else
						TABLE_TableIndirection["Type%0"] = gBit(TABLE_TableIndirection["Descriptor%0"], 5 - 3, 5 - 2);
						TABLE_TableIndirection["Mask%0"] = gBit(TABLE_TableIndirection["Descriptor%0"], 3 + 1, 1003 - (915 + 82));
						TABLE_TableIndirection["FlatIdent_2F37F%0"] = 1;
					end
					if (3 ~= TABLE_TableIndirection["FlatIdent_2F37F%0"]) then
					else
						if ((428 < 1804) and (gBit(TABLE_TableIndirection["Mask%0"], 3, 1 + 2) == 1)) then
							TABLE_TableIndirection["Inst%0"][4] = TABLE_TableIndirection["Consts%0"][TABLE_TableIndirection["Inst%0"][4]];
						end
						TABLE_TableIndirection["Instrs%0"][Idx] = TABLE_TableIndirection["Inst%0"];
						break;
					end
					if (TABLE_TableIndirection["FlatIdent_2F37F%0"] ~= 1) then
					else
						TABLE_TableIndirection["Inst%0"] = {gBits16(),gBits16(),nil,nil};
						if (TABLE_TableIndirection["Type%0"] == 0) then
							TABLE_TableIndirection["FlatIdent_7DD24%0"] = 0;
							while true do
								if (TABLE_TableIndirection["FlatIdent_7DD24%0"] == 0) then
									TABLE_TableIndirection["Inst%0"][6 - 3] = gBits16();
									TABLE_TableIndirection["Inst%0"][4] = gBits16();
									break;
								end
							end
						elseif ((TABLE_TableIndirection["Type%0"] == (1 - 0)) or (3325 > 4613)) then
							TABLE_TableIndirection["Inst%0"][3] = gBits32();
						elseif (TABLE_TableIndirection["Type%0"] == (1 + 1)) then
							TABLE_TableIndirection["Inst%0"][4 - 1] = gBits32() - ((2 + 0) ^ (807 - (368 + 423)));
						elseif ((TABLE_TableIndirection["Type%0"] ~= (9 - 6)) or (4950 <= 4553)) then
						else
							TABLE_TableIndirection["FlatIdent_781F8%0"] = 0;
							while true do
								if (TABLE_TableIndirection["FlatIdent_781F8%0"] ~= 0) then
								else
									TABLE_TableIndirection["Inst%0"][21 - (10 + 8)] = gBits32() - ((7 - 5) ^ 16);
									TABLE_TableIndirection["Inst%0"][4] = gBits16();
									break;
								end
							end
						end
						TABLE_TableIndirection["FlatIdent_2F37F%0"] = 2;
					end
				end
			end
		end
		for Idx = 1 + 0, gBits32() do
			TABLE_TableIndirection["Functions%0"][Idx - 1] = Deserialize();
		end
		return TABLE_TableIndirection["Chunk%0"];
	end
	local function Wrap(Chunk, Upvalues, Env)
		TABLE_TableIndirection["Instr%0"] = Chunk[773 - (201 + 571)];
		TABLE_TableIndirection["Proto%0"] = Chunk[2];
		TABLE_TableIndirection["Params%0"] = Chunk[3];
		return function(...)
			TABLE_TableIndirection["Instr%1"] = TABLE_TableIndirection["Instr%0"];
			TABLE_TableIndirection["Proto%1"] = TABLE_TableIndirection["Proto%0"];
			TABLE_TableIndirection["Params%1"] = TABLE_TableIndirection["Params%0"];
			TABLE_TableIndirection["_R%1"] = _R;
			TABLE_TableIndirection["VIP%0"] = 1139 - (116 + 1022);
			TABLE_TableIndirection["Top%0"] = -(4 - 3);
			TABLE_TableIndirection["Vararg%0"] = {};
			TABLE_TableIndirection["Args%0"] = {...};
			TABLE_TableIndirection["PCount%0"] = TABLE_TableIndirection["Select%0"]("#", ...) - 1;
			TABLE_TableIndirection["Lupvals%0"] = {};
			TABLE_TableIndirection["Stk%0"] = {};
			for Idx = 0, TABLE_TableIndirection["PCount%0"] do
				if (Idx >= TABLE_TableIndirection["Params%1"]) then
					TABLE_TableIndirection["Vararg%0"][Idx - TABLE_TableIndirection["Params%1"]] = TABLE_TableIndirection["Args%0"][Idx + (3 - 2)];
				else
					TABLE_TableIndirection["Stk%0"][Idx] = TABLE_TableIndirection["Args%0"][Idx + 1];
				end
			end
			TABLE_TableIndirection["Varargsz%0"] = (TABLE_TableIndirection["PCount%0"] - TABLE_TableIndirection["Params%1"]) + (3 - 2);
			TABLE_TableIndirection["Inst%0"] = nil;
			TABLE_TableIndirection["Enum%0"] = nil;
			while true do
				TABLE_TableIndirection["FlatIdent_E652%0"] = 0;
				while true do
					if (TABLE_TableIndirection["FlatIdent_E652%0"] ~= 1) then
					else
						if ((2665 <= 3933) and (TABLE_TableIndirection["Enum%0"] <= 15)) then
							if (TABLE_TableIndirection["Enum%0"] <= (866 - (814 + 45))) then
								if ((3273 == 3273) and (TABLE_TableIndirection["Enum%0"] <= (7 - 4))) then
									if ((3824 > 409) and (TABLE_TableIndirection["Enum%0"] <= 1)) then
										if ((2087 == 2087) and (TABLE_TableIndirection["Enum%0"] > (0 + 0))) then
											TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1 + 1]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][888 - (261 + 624)]] - TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][6 - 2]];
										else
											TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["Inst%0"][1083 - (1020 + 60)];
										end
									elseif ((TABLE_TableIndirection["Enum%0"] > (1425 - (630 + 793))) or (3404 > 4503)) then
										TABLE_TableIndirection["FlatIdent_6053C%0"] = 0;
										TABLE_TableIndirection["A%0"] = nil;
										while true do
											if (TABLE_TableIndirection["FlatIdent_6053C%0"] ~= 0) then
											else
												TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][6 - 4];
												TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]](TABLE_TableIndirection["Unpack%0"](TABLE_TableIndirection["Stk%0"], TABLE_TableIndirection["A%0"] + 1, TABLE_TableIndirection["Inst%0"][14 - 11]));
												break;
											end
										end
									else
										TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1 + 1]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][3]][TABLE_TableIndirection["Inst%0"][4]];
									end
								elseif ((TABLE_TableIndirection["Enum%0"] <= 5) or (3506 <= 1309)) then
									if ((2955 == 2955) and (TABLE_TableIndirection["Enum%0"] == 4)) then
										do
											return;
										end
									else
										TABLE_TableIndirection["FlatIdent_1A54%0"] = 0;
										TABLE_TableIndirection["A%0"] = nil;
										while true do
											if ((0 ~= TABLE_TableIndirection["FlatIdent_1A54%0"]) or (2903 == 1495)) then
											else
												TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][2];
												TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]]();
												break;
											end
										end
									end
								elseif ((4546 >= 2275) and (TABLE_TableIndirection["Enum%0"] > (20 - 14))) then
									if TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] then
										TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["VIP%0"] + (1748 - (760 + 987));
									else
										TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["Inst%0"][1916 - (1789 + 124)];
									end
								else
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][768 - (745 + 21)]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2 + 1]] + TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][10 - 6]];
								end
							elseif (TABLE_TableIndirection["Enum%0"] <= 11) then
								if (TABLE_TableIndirection["Enum%0"] <= 9) then
									if ((819 >= 22) and (TABLE_TableIndirection["Enum%0"] == (31 - 23))) then
										TABLE_TableIndirection["FlatIdent_61800%0"] = 0;
										TABLE_TableIndirection["A%0"] = nil;
										TABLE_TableIndirection["B%0"] = nil;
										while true do
											if (TABLE_TableIndirection["FlatIdent_61800%0"] ~= 0) then
											else
												TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][2];
												TABLE_TableIndirection["B%0"] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1 + 2]];
												TABLE_TableIndirection["FlatIdent_61800%0"] = 1;
											end
											if ((3162 == 3162) and (TABLE_TableIndirection["FlatIdent_61800%0"] == 1)) then
												TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"] + 1] = TABLE_TableIndirection["B%0"];
												TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]] = TABLE_TableIndirection["B%0"][TABLE_TableIndirection["Inst%0"][4]];
												break;
											end
										end
									else
										TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2 + 0]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][3]];
									end
								elseif ((TABLE_TableIndirection["Enum%0"] == (1065 - (87 + 968))) or (2369 > 4429)) then
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][8 - 6]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][3 + 0]][TABLE_TableIndirection["Inst%0"][4]];
								else
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][4 - 2]][TABLE_TableIndirection["Inst%0"][3]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1417 - (447 + 966)]];
								end
							elseif ((4095 >= 3183) and (TABLE_TableIndirection["Enum%0"] <= (35 - 22))) then
								if (TABLE_TableIndirection["Enum%0"] == (1829 - (1703 + 114))) then
									if (TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][703 - (376 + 325)]] < TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][4]]) then
										TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["VIP%0"] + 1;
									else
										TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["Inst%0"][3];
									end
								else
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = Env[TABLE_TableIndirection["Inst%0"][3]];
								end
							elseif (TABLE_TableIndirection["Enum%0"] > (22 - 8)) then
								do
									return;
								end
							else
								TABLE_TableIndirection["FlatIdent_8F59B%0"] = 0;
								TABLE_TableIndirection["A%0"] = nil;
								while true do
									if (TABLE_TableIndirection["FlatIdent_8F59B%0"] ~= 0) then
									else
										TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][2];
										TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]](TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"] + (2 - 1)]);
										break;
									end
								end
							end
						elseif (TABLE_TableIndirection["Enum%0"] <= (7 + 16)) then
							if (TABLE_TableIndirection["Enum%0"] <= 19) then
								if ((TABLE_TableIndirection["Enum%0"] <= (37 - 20)) or (3711 < 1008)) then
									if (TABLE_TableIndirection["Enum%0"] > 16) then
										if ((TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][16 - (9 + 5)]] < TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][4]]) or (1049 <= 906)) then
											TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["VIP%0"] + (377 - (85 + 291));
										else
											TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["Inst%0"][1268 - (243 + 1022)];
										end
									else
										TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["Inst%0"][11 - 8];
									end
								elseif (TABLE_TableIndirection["Enum%0"] > 18) then
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = Wrap(TABLE_TableIndirection["Proto%1"][TABLE_TableIndirection["Inst%0"][3]], nil, Env);
								else
									TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][2 + 0];
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]]();
								end
							elseif ((4513 > 2726) and (TABLE_TableIndirection["Enum%0"] <= (1201 - (1123 + 57)))) then
								if (TABLE_TableIndirection["Enum%0"] > (17 + 3)) then
									TABLE_TableIndirection["FlatIdent_2AC68%0"] = 0;
									TABLE_TableIndirection["A%0"] = nil;
									while true do
										if ((TABLE_TableIndirection["FlatIdent_2AC68%0"] ~= 0) or (1481 >= 2658)) then
										else
											TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][2];
											TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]](TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"] + 1]);
											break;
										end
									end
								else
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = TABLE_TableIndirection["Inst%0"][3];
								end
							elseif ((TABLE_TableIndirection["Enum%0"] > 22) or (3220 == 1364)) then
								TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][256 - (163 + 91)]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][3]] + TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][4]];
							else
								TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][3]];
							end
						elseif (TABLE_TableIndirection["Enum%0"] <= (1957 - (1869 + 61))) then
							if ((TABLE_TableIndirection["Enum%0"] <= 25) or (1054 > 3392)) then
								if ((TABLE_TableIndirection["Enum%0"] > (7 + 17)) or (676 >= 1642)) then
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = TABLE_TableIndirection["Inst%0"][10 - 7];
								else
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2 - 0]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1 + 2]] - TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][5 - 1]];
								end
							elseif (TABLE_TableIndirection["Enum%0"] > (25 + 1)) then
								if ((4136 > 2397) and TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1476 - (1329 + 145)]]) then
									TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["VIP%0"] + 1;
								else
									TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["Inst%0"][974 - (140 + 831)];
								end
							else
								TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = Env[TABLE_TableIndirection["Inst%0"][3]];
							end
						elseif ((TABLE_TableIndirection["Enum%0"] <= (1879 - (1409 + 441))) or (4334 == 4245)) then
							if ((TABLE_TableIndirection["Enum%0"] > (746 - (15 + 703))) or (4276 <= 3031)) then
								TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][2]] = Wrap(TABLE_TableIndirection["Proto%1"][TABLE_TableIndirection["Inst%0"][2 + 1]], nil, Env);
							else
								TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][440 - (262 + 176)];
								TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]](TABLE_TableIndirection["Unpack%0"](TABLE_TableIndirection["Stk%0"], TABLE_TableIndirection["A%0"] + 1, TABLE_TableIndirection["Inst%0"][3]));
							end
						elseif ((TABLE_TableIndirection["Enum%0"] == 30) or (4782 <= 1199)) then
							TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][1723 - (345 + 1376)]][TABLE_TableIndirection["Inst%0"][691 - (198 + 490)]] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][17 - 13]];
						else
							TABLE_TableIndirection["FlatIdent_1B51D%0"] = 0;
							TABLE_TableIndirection["A%0"] = nil;
							TABLE_TableIndirection["B%0"] = nil;
							while true do
								if (TABLE_TableIndirection["FlatIdent_1B51D%0"] ~= 1) then
								else
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"] + (2 - 1)] = TABLE_TableIndirection["B%0"];
									TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["A%0"]] = TABLE_TableIndirection["B%0"][TABLE_TableIndirection["Inst%0"][4]];
									break;
								end
								if ((TABLE_TableIndirection["FlatIdent_1B51D%0"] ~= 0) or (4864 < 1902)) then
								else
									TABLE_TableIndirection["A%0"] = TABLE_TableIndirection["Inst%0"][2];
									TABLE_TableIndirection["B%0"] = TABLE_TableIndirection["Stk%0"][TABLE_TableIndirection["Inst%0"][3]];
									TABLE_TableIndirection["FlatIdent_1B51D%0"] = 1;
								end
							end
						end
						TABLE_TableIndirection["VIP%0"] = TABLE_TableIndirection["VIP%0"] + 1;
						break;
					end
					if ((4839 >= 3700) and (0 ~= TABLE_TableIndirection["FlatIdent_E652%0"])) then
					else
						TABLE_TableIndirection["Inst%0"] = TABLE_TableIndirection["Instr%1"][TABLE_TableIndirection["VIP%0"]];
						TABLE_TableIndirection["Enum%0"] = TABLE_TableIndirection["Inst%0"][1];
						TABLE_TableIndirection["FlatIdent_E652%0"] = 1;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!083O0003093O0052617269747947657403093O00536163726966696365030A3O005570677261646553504D030B3O00557067726164654C75636B03043O007469636B024O00C0F2F04002EC51B81E85EBC13F03043O007761697400283O0012143O00013O001214000100023O001214000200033O001214000300043O00021300045O00120D000500054O0005000500010002001214000600063O001214000700073O00120D000800054O00050008000100022O001800080008000500061100080027000100060004103O002700012O0016000800044O001600096O001500080002000100120D000800084O0016000900074O00150008000200012O0016000800044O0016000900014O001500080002000100120D000800084O0016000900074O00150008000200012O0016000800044O0016000900024O001500080002000100120D000800084O0016000900074O00150008000200012O0016000800044O0016000900034O001500080002000100120D000800084O0016000900074O00150008000200010004103O000900012O00043O00013O00013O000E3O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O00436861726163746572030E3O0046696E6446697273744368696C6403103O0048756D616E6F6964522O6F745061727403093O00576F726B73706163652O033O0049734103083O00426173655061727403063O00434672616D6503073O00566563746F72332O033O006E6577028O00026O00084001263O00120D000100013O00200A00010001000200200A00010001000300061B0001002500013O0004103O0025000100200A00020001000400061B0002002500013O0004103O0025000100200A00020001000400201F000200020005001214000400064O001C00020004000200061B0002002500013O0004103O0025000100120D000200013O00200A00020002000700201F0002000200052O001600046O001C00020004000200061B0002002500013O0004103O0025000100201F000300020008001214000500094O001C00030005000200061B0003002500013O0004103O0025000100200A00030001000400200A00030003000600200A00040002000A00120D0005000B3O00200A00050005000C0012140006000D3O0012140007000E3O0012140008000D4O001C0005000800022O000600040004000500101E0003000A00042O00043O00017O00", TABLE_TableIndirection["GetFEnv%0"](), ...);
