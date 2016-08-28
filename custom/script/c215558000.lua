--パラサイト・フュージョナー
--Parasite Fusioner
--Anime original, altered and scripted by Eerie Code
function c215558000.initial_effect(c)
	c:SetSPSummonOnce(215558000)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c215558000.tg)
	e1:SetOperation(c215558000.op)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c215558000.valcon)
	c:RegisterEffect(e3)
end

function c215558000.nmfil(c)
	--Debug.Message("Declared: "..c:GetCode()..", ATK "..c:GetAttack())
	if not c:IsType(TYPE_MONSTER) then 
		--Debug.Message("Not a monster. "..c:GetType())
		return false
	elseif c:IsType(TYPE_FUSION) then
		return false
	elseif c:IsSetCard(0x9b) then
		--Debug.Message("Melodious")
		return true
	elseif c:IsSetCard(0xdf) then
		--Debug.Message("Lunalight")
		return true
	elseif c:IsSetCard(0xf0) then
		--Debug.Message("Wind Witch")
		return true
	elseif c:IsSetCard(0xeda) then
		--Debug.Message("Lyrical Luscinia")
		return true
	else
		return false
	end
	--return (c:IsSetCard(0x9b) or c:IsSetCard(0xdf) or c:IsSetCard(0xf0) or c:IsSetCard(0xba))
end
function c215558000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ac=0
	local lp=true
	while lp do
		ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
		local tk=Duel.CreateToken(tp,ac)
		if c215558000.nmfil(tk) then lp=false end
	end
	--Debug.Message("Fusion Tag: "..ac)
	Duel.SetTargetParam(ac)
	e:SetLabel(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c215558000.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c215558000.filter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c215558000.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if ac==0 then ac=e:GetLabel() end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	--Debug.Message("Fusion Tag: "..ac)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59432181,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_FUSION_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(ac)
	c:RegisterEffect(e1)
	Duel.BreakEffect()
	local mg1=Duel.GetMatchingGroup(c215558000.filter1,tp,LOCATION_MZONE,0,c,e)
	local sg1=Duel.GetMatchingGroup(c215558000.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c215558000.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c)
	end
	--Debug.Message("Fusion Monster count: "..sg1:GetCount())
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	local sc=Duel.GetOperatedGroup():GetFirst()
	if not sc or not c:IsLocation(LOCATION_GRAVE) then return end
	Duel.Equip(tp,c,sc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c215558000.eqlimit)
	e1:SetLabelObject(sc)
	c:RegisterEffect(e1)
end
function c215558000.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function c215558000.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return true
	else return false end
end
