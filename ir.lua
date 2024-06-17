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

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local b = Rep(a, repeatNext);
				repeatNext = nil;
				return b;
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				Exponent = 1;
				IsNormal = 0;
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local Str;
		if not Len then
			Len = gBits32();
			if (Len == 0) then
				return "";
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local Type = gBits8();
			local Cons;
			if (Type == 1) then
				Cons = gBits8() ~= 0;
			elseif (Type == 2) then
				Cons = gFloat();
			elseif (Type == 3) then
				Cons = gString();
			end
			Consts[Idx] = Cons;
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local Type = gBit(Descriptor, 2, 3);
				local Mask = gBit(Descriptor, 4, 6);
				local Inst = {gBits16(),gBits16(),nil,nil};
				if (Type == 0) then
					Inst[3] = gBits16();
					Inst[4] = gBits16();
				elseif (Type == 1) then
					Inst[3] = gBits32();
				elseif (Type == 2) then
					Inst[3] = gBits32() - (2 ^ 16);
				elseif (Type == 3) then
					Inst[3] = gBits32() - (2 ^ 16);
					Inst[4] = gBits16();
				end
				if (gBit(Mask, 1, 1) == 1) then
					Inst[2] = Consts[Inst[2]];
				end
				if (gBit(Mask, 2, 2) == 1) then
					Inst[3] = Consts[Inst[3]];
				end
				if (gBit(Mask, 3, 3) == 1) then
					Inst[4] = Consts[Inst[4]];
				end
				Instrs[Idx] = Inst;
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 15) then
					if (Enum <= 7) then
						if (Enum <= 3) then
							if (Enum <= 1) then
								if (Enum == 0) then
									VIP = Inst[3];
								else
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum == 2) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 5) then
							if (Enum > 4) then
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							else
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum > 6) then
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						else
							do
								return;
							end
						end
					elseif (Enum <= 11) then
						if (Enum <= 9) then
							if (Enum == 8) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								do
									return;
								end
							end
						elseif (Enum > 10) then
							local A = Inst[2];
							Stk[A](Stk[A + 1]);
						else
							Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
						end
					elseif (Enum <= 13) then
						if (Enum == 12) then
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum == 14) then
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
					else
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					end
				elseif (Enum <= 23) then
					if (Enum <= 19) then
						if (Enum <= 17) then
							if (Enum > 16) then
								Stk[Inst[2]] = Inst[3];
							else
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum > 18) then
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
					elseif (Enum <= 21) then
						if (Enum == 20) then
							VIP = Inst[3];
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
					elseif (Enum == 22) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
					else
						Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
					end
				elseif (Enum <= 27) then
					if (Enum <= 25) then
						if (Enum > 24) then
							Stk[Inst[2]] = Stk[Inst[3]];
						else
							Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
						end
					elseif (Enum > 26) then
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local A = Inst[2];
						Stk[A] = Stk[A]();
					end
				elseif (Enum <= 29) then
					if (Enum == 28) then
						Stk[Inst[2]] = Stk[Inst[3]];
					elseif Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum == 30) then
					Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
				else
					local A = Inst[2];
					Stk[A] = Stk[A]();
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!083O0003093O0052617269747947657403093O00536163726966696365030A3O005570677261646553504D030B3O00557067726164654C75636B03043O007469636B024O00C0F2F04002EC51B81E85EBC13F03043O007761697400283O0012103O00013O001210000100023O001210000200033O001210000300043O00020A00045O002O12000500054O001F000500010002001210000600063O001210000700073O002O12000800054O001F0008000100022O000100080008000500060800080027000100060004143O002700012O001C000800044O001C00096O000B000800020001002O12000800084O001C000900074O000B0008000200012O001C000800044O001C000900014O000B000800020001002O12000800084O001C000900074O000B0008000200012O001C000800044O001C000900024O000B000800020001002O12000800084O001C000900074O000B0008000200012O001C000800044O001C000900034O000B000800020001002O12000800084O001C000900074O000B0008000200010004143O000900012O00093O00013O00013O000E3O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O00436861726163746572030E3O0046696E6446697273744368696C6403103O0048756D616E6F6964522O6F745061727403093O00576F726B73706163652O033O0049734103083O00426173655061727403063O00434672616D6503073O00566563746F72332O033O006E6577028O00026O00084001263O002O12000100013O00200C00010001000200200C00010001000300061D0001002500013O0004143O0025000100200C00020001000400061D0002002500013O0004143O0025000100200C000200010004002004000200020005001210000400064O000D00020004000200061D0002002500013O0004143O00250001002O12000200013O00200C0002000200070020040002000200052O001C00046O000D00020004000200061D0002002500013O0004143O00250001002004000300020008001210000500094O000D00030005000200061D0003002500013O0004143O0025000100200C00030001000400200C00030003000600200C00040002000A002O120005000B3O00200C00050005000C0012100006000D3O0012100007000E3O0012100008000D4O000D0005000800022O001E0004000400050010050003000A00042O00093O00017O00", GetFEnv(), ...);
