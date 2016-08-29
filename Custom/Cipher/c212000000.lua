--ＲＵＭ－光波追撃
--Rank-Up-Magic Cipher Pursuit
--Scripted by Eerie Code
function c212000000.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c212000000.condition)
	e1:SetTarget(c212000000.target)
	e1:SetOperation(c212000000.activate)
	c:RegisterEffect(e1)
end

function c212000000.condition(e,tp,eg,ep,ev,re,r,rp)
	return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>=2000
end
function c212000000.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>1 and c:IsFaceup() and c:IsSetCard(0xe5)
		and Duel.IsExistingMatchingCard(c212000000.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
end
function c212000000.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk+1 and c:IsSetCard(0xe5) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c212000000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c212000000.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c212000000.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c212000000.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c212000000.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c212000000.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local code=sc:GetCode()
		local te=Effect.CreateEffect(sc)
		te:SetType(EFFECT_TYPE_SINGLE)
		te:SetCode(511002571)
		sc:RegisterEffect(te)
		local con=nil
		local cost=nil
		local tg=nil
		local op=nil
		if sc:IsCode(18963306) then --GECD
			cost=sc.cost
			tg=sc.target
			op=sc.operation
		elseif sc:IsCode(7549,212000035,212000036) then --NeoGECD, CRW, CBW
			con=sc.con
			cost=sc.cost
			tg=sc.target
			op=sc.operation
		elseif sc:IsCode(2530830) then --GECBD
			cost=sc.descost
			tg=sc.destg
			op=sc.desop
		end
		local con_check=(not con or con(te,tp,eg,ep,ev,re,r,rp))
		local cost_check=(cost and cost(te,tp,eg,ep,ev,re,r,rp,0))
		local tg_check=(not tg or tg(te,tp,eg,ep,ev,re,r,rp,0))
		if con_check and cost_check and tg_check and Duel.SelectYesNo(tp,aux.Stringid(1012,0)) then
			cost(te,tp,eg,ep,ev,re,r,rp,1)
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			Duel.BreakEffect()
			sc:CreateEffectRelation(te)
			Duel.BreakEffect()
			local xg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local etc=nil
			if xg then
				etc=xg:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=xg:GetNext()
				end
			end
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			sc:ReleaseEffectRelation(te)
			if etc then 
				etc=xg:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=xg:GetNext()
				end
			end
		end
	end
end
