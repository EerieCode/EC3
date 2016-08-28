--ＲＲ－ラピッド・エクシーズ
--Raidraptor - Rapid Xyz
--Created by Wave., scripted by Eerie Code
function c215444000.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c215444000.xyzcon)
	e1:SetTarget(c215444000.xyztg)
	e1:SetOperation(c215444000.xyzop)
	c:RegisterEffect(e1)
end

function c215444000.cfil(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c215444000.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(c215444000.cfil,tp,0,LOCATION_MZONE,1,nil)
end
function c215444000.xyzfilter(c)
	return c:IsSetCard(0xba) and c:IsXyzSummonable(nil)
end
function c215444000.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c215444000.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c215444000.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c215444000.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		local sc=tg:GetFirst()
		Duel.XyzSummon(tp,sc,nil)
		local code=sc:GetCode()
		local te=Effect.CreateEffect(sc)
		te:SetType(EFFECT_TYPE_SINGLE)
		te:SetCode(511002571)
		sc:RegisterEffect(te)
		local con=nil
		local cost=nil
		local tg=nil
		local op=nil
		if sc:IsCode(86221741) then --Ultimate
			cost=sc.cost
			op=sc.operation
		elseif sc:IsCode(23603403) then --Satellite
			con=sc.atkcon
			cost=sc.atkcost
			tg=sc.atktg
			op=sc.atkop
		elseif sc:IsCode(81927732) then --Revolution
			con=sc.condition
			cost=sc.cost
			op=sc.operation
		elseif sc:IsCode(45533023) then --Blaze
			cost=sc.descost
			tg=sc.destg2
			op=sc.desop2
		elseif sc:IsCode(96592102) then --Blade Burner
			con=aux.bdocon
			cost=sc.descost
			tg=sc.destg
			op=sc.desop
		elseif sc:IsCode(73347079) then --Force
			cost=sc.thcost
			tg=sc.thtg
			op=sc.thop
		elseif sc:IsCode(73887236,52323874) then --Rise, Fiend
			cost=sc.cost
			tg=sc.target
			op=sc.operation
		elseif sc:IsCode(215444050) then --Angelic
			cost=sc.poscost
			tg=sc.postg
			op=sc.posop
		end
		local con_check=(not con or con(te,tp,eg,ep,ev,re,r,rp))
		local cost_check=(cost and cost(te,tp,eg,ep,ev,re,r,rp,0))
		local tg_check=(not tg or tg(te,tp,eg,ep,ev,re,r,rp,0))
		if con_check and cost_check and tg_check and Duel.SelectYesNo(tp,aux.Stringid(1017,1)) then
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
