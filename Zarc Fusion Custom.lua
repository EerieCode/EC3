--Fusion monster, X conditions
function Auxiliary.AddFusionProcFunMulti(c,insf,...)
	local funs=...
	local n=#funs
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionFunMulti(funs,n,insf))
	e1:SetOperation(Auxiliary.FOperationFunMulti(funs,n,insf))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionFilterMultiOr(c,funs,n)
	for i=1,n do
		if funs[i](c) then return true end
	end
	return false
end
function Auxiliary.FConditionFilterMulti(c,mg,funs,n,tbt)
	for i=1,n do
		local tp=2^(i-1)
		if bit.band(tbt,tp)~=0 and funs[i](c) then
			local t2=tbt-tp
			if t2==0 then return true end
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(Auxiliary.FConditionFilterMulti,1,nil,mg2,funs,n,t2) then return true end
		end
	end
	return false
end
function Auxiliary.CloneTable(g)
	return {table.unpack(g)}
end
function Auxiliary.FConditionFilterMulti2(c,gr)
	local gr2=Auxiliary.CloneTable(gr)
	for i=1,#gr2 do
		gr2[i]:RemoveCard(c)
	end
	table.remove(gr2,1)
	if #gr2==1 then
		return gr2[1]:IsExists(aux.TRUE,1,nil)
	else
		return gr2[1]:IsExists(Auxiliary.FConditionFilterMulti2,1,nil,gr2)
	end
end
function Auxiliary.FConditionFilterMultiSelect(c,funs,n,mg,sg)
	local valid=Auxiliary.FConditionFilterMultiValid(sg,funs,n)
	if not valid then valid={0} end	
	local all = (2^n)-1
	for k,v in pairs(valid) do
		v=bit.bxor(all,v)
		if Auxiliary.FConditionFilterMulti(c,mg,funs,n,v) then return true end
	end
	return false
end
function Auxiliary.FConditionFilterMultiValid(g,funs,n)
	local tp={}
	local tc=g:GetFirst()
	while tc do
		local tp1={}
		for i=1,n do
			if funs[i](tc) then table.insert(tp1,2^(i-1)) end
		end
		table.insert(tp,tp1)
		tc=g:GetNext()
	end
	return Auxiliary.FConditionMultiGenerateValids(tp,n)
end
function Auxiliary.FConditionMultiGenerateValids(vs,n)
	local c=2
	while #vs > 1 do
		local v1=vs[1]
		table.remove(vs,1)
		local v2=vs[1]
		table.remove(vs,1)
		table.insert(vs,1,Auxiliary.FConditionMultiCombine(v1,v2,n,c))
		c=c+1
	end
	return vs[1]
end
function Auxiliary.FConditionMultiCombine(t1,t2,n,c)
	local res={}
	for k1,v1 in pairs(t1) do
		for k2,v2 in pairs(t2) do
			table.insert(res,bit.bor(v1,v2))
		end
	end	
	res=Auxiliary.FConditionMultiCheckCount(res,n)
	return Auxiliary.FConditionFilterMultiClean(res)
end
function Auxiliary.FConditionMultiCheckCount(vals,n)
	local res={} local flags={}
	for k,v in pairs(vals) do
		local c=0
		for i=1,n do
			if bit.band(v,2^(i-1))~=0 then c=c+1 end
		end
		if not flags[c] then
			res[c] = {v}
			flags[c] = true
		else
			table.insert(res[c],v)
		end
	end
	local mk=0
	for k,v in pairs(flags) do
		if k>mk then mk=k end
	end
	return res[mk]
end
function Auxiliary.FConditionFilterMultiClean(vals)
	local res={} local flags={}
	for k,v in pairs(vals) do
		if not flags[v] then
			table.insert(res,v)
			flags[v] = true
		end
	end
	return res
end
function Auxiliary.FConditionFunMulti(funs,n,insf)
	return function(e,g,gc,chkfnf)
		local c=e:GetHandler()
		if g==nil then return insf end
		if not c:IsFacedown() then return false end
		local chkf=bit.band(chkfnf,0xff)
		local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,c):Filter(Auxiliary.FConditionFilterMultiOr,nil,funs,n)
		if gc then
			if not gc:IsCanBeFusionMaterial(c) then return false end
			local check_tot=(2^n)-1
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			for i=1,n do
				if funs[i](gc) then
					local tbt=check_tot-2^(i-1)
					if mg2:IsExists(Auxiliary.FConditionFilterMulti,1,nil,mg2,funs,n,tbt) then return true end
				end
			end
			return false
		end
		local fs=false
		local groups={}
		for i=1,n do
			table.insert(groups,Group.CreateGroup())
		end
		local tc=mg:GetFirst()
		while tc do
			for i=1,n do
				if funs[i](tc) then
					groups[i]:AddCard(tc)
					if Auxiliary.FConditionCheckF(tc,chkf) then fs=true end
				end
			end
			tc=mg:GetNext()
		end
		if chkf~=PLAYER_NONE then
			if not fs then return false end
			local gr2=Auxiliary.CloneTable(groups)
			return gr2[1]:IsExists(Auxiliary.FConditionFilterMulti2,1,nil,gr2)
		end
	end
end
function Auxiliary.FOperationFunMulti(funs,n,insf)
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local c=e:GetHandler()
		local chkf=bit.band(chkfnf,0xff)
		local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,c):Filter(Auxiliary.FConditionFilterMultiOr,nil,funs,n)
		if gc then
			local sg=Group.FromCards(gc)
			local mg=g:Clone()
			mg:RemoveCard(gc)
			for i=1,n-1 do
				local mg2=mg:Filter(Auxiliary.FConditionFilterMultiSelect,nil,funs,n,mg,sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg2=mg2:Select(tp,1,1,nil)
				sg:AddCard(sg2:GetFirst())
				mg:RemoveCard(sg2:GetFirst())
			end
			Duel.SetFusionMaterial(sg)
			return
		end
		local sg=Group.CreateGroup()
		local mg=g:Clone()
		for i=1,n do
			local mg2=mg:Filter(Auxiliary.FConditionFilterMultiSelect,nil,funs,n,mg,sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg2=nil
			if i==1 and chkf~=PLAYER_NONE then
				sg2=mg2:FilterSelect(tp,Auxiliary.FConditionCheckF,1,1,nil,chkf)
			else
				sg2=mg2:Select(tp,1,1,nil)
			end
			sg:AddCard(sg2:GetFirst())
			mg:RemoveCard(sg2:GetFirst())
		end
		Duel.SetFusionMaterial(sg)
	end
end
