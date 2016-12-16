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
function Auxiliary.FConditionFilterMulti(c,mg,funs,n,tbt)
	for i=1,n do
		if bit.band(tbt,2^i)~=0 and funs[i](c) then
			local t2=tbt-2^i
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
function Auxiliary.FConditionFunMulti(funs,n,insf)
	return function(e,g,gc,chkfnf)
		local c=e:GetHandler()
		if g==nil then return insf end
		if not c:IsFacedown() then return false end
		local chkf=bit.band(chkfnf,0xff)
		local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,c)
		if gc then
			if not gc:IsCanBeFusionMaterial(c) then return false end
			local check_tot=(2^n)-1
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			for i=1,n do
				if funs[i](gc) then
					local tbt=check_tot-2^i
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
		local eg=g:Filter(Card.IsCanBeFusionMaterial,nil,c)
		if gc then
			local mg=eg:Clone()
			mg:RemoveCard(gc)
			local g1=Group.FromCards(gc)
			for i=1,n-1 do
				local sg=Group.CreateGroup()
				local tbt=(2^n)-1
				for j=1,n do
					if funs[j](gc) then
						sg:Merge(mg:Filter(Auxiliary.FConditionFilterMulti,nil,mg,funs,n,tbt-2^j))
					end
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local g2=sg:Select(tp,1,1,nil)
				g1:AddCard(g2:GetFirst())
				mg:RemoveCard(g2:GetFirst())
			end
			Duel.SetFusionMaterial(g1)
			return
		end
		--To be done
		local g1=Group.CreateGroup()
		for i=1,n do
			
		end
	end
end
