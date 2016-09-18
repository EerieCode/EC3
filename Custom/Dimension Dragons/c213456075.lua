--ペンデュラム・パンディモニウム
--Pendulum Pandemonium
--Created and scripted by Eerie Code
function c213456075.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,213456075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c213456075.condition)
	e1:SetTarget(c213456075.target)
	e1:SetOperation(c213456075.activate)
	c:RegisterEffect(e1)
end

function c213456075.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsRelateToBattle() and tc:IsStatus(STATUS_OPPO_BATTLE) and tc:IsControler(tp) and (tc:IsSetCard(0xf1) or (tc:IsSetCard(0x99) and tc:IsType(TYPE_PENDULUM))) and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c213456075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c213456075.spfil(c,e,tp,mg)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xf1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg)
end
function c213456075.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b=Duel.IsPlayerCanSpecialSummonCount(tp,2)
	local ac=eg:GetFirst()
	if not ac then return end
	local bc=ac:GetBattleTarget()
	if bc:IsLocation(LOCATION_GRAVE) and Duel.SpecialSummon(bc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		bc:RegisterEffect(e2,true)
		if not b then return end
		if not ac:IsCanBeFusionMaterial() or not bc:IsCanBeFusionMaterial() then return end
		local mg=Group.FromCards(ac,bc)
		local g=Duel.GetMatchingGroup(c213456075.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			sc:SetMaterial(mg)
			Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
end
