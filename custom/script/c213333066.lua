--プレデター・ダイジェスト
--Predator Digestion
--Created and scripted by Eerie Code
function c213333066.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,213333066)
	e1:SetCondition(c213333066.con1)
	e1:SetTarget(c213333066.tg1)
	e1:SetOperation(c213333066.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c213333066.con2)
	e2:SetTarget(c213333066.tg2)
	c:RegisterEffect(e2)
end

function c213333066.con1(e,tp,eg,ep,ev,re,r,rp)
	if not eg or eg:GetCount()>1 then return false end
	local om=eg:GetFirst()
	local pm=om:GetBattleTarget()
	return om:IsControler(1-tp) and om:IsLocation(LOCATION_GRAVE) and pm:IsControler(tp) and pm:IsRelateToBattle() and pm:IsControler(tp) and pm:IsAttribute(ATTRIBUTE_DARK) and pm:IsRace(RACE_PLANT)
end
function c213333066.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local om=eg:GetFirst()
	local pm=om:GetBattleTarget()
	if chk==0 then return pm:IsFaceup() and pm:IsLocation(LOCATION_MZONE) and pm:IsCanBeEffectTarget(e) and om:IsCanBeEffectTarget(e) and om:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tg=Group.FromCards(pm,om)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,om,1,nil,nil)
end

function c213333066.fil2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetPreviousLocation()==LOCATION_MZONE and c:GetPreviousControler()==1-tp and c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp) and c:IsReason(REASON_EFFECT)
end
function c213333066.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return eg and eg:GetCount()==1 and eg:IsExists(c213333066.fil2,1,nil,e,tp) and re:IsActiveType(TYPE_MONSTER) and rc:IsAttribute(ATTRIBUTE_DARK) and rc:IsRace(RACE_PLANT) and rc:IsControler(tp)
end
function c213333066.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local om=eg:GetFirst()
	local pm=re:GetHandler()
	if chk==0 then return pm and pm:IsFaceup() and pm:IsLocation(LOCATION_MZONE) and pm:IsCanBeEffectTarget(e) and om and om:IsCanBeEffectTarget(e) and om:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tg=Group.FromCards(pm,om)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,om,1,nil,nil)
end

function c213333066.fsfil(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFacedown() and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m)
end
function c213333066.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	local pm=tg:GetFirst()
	local om=tg:GetNext()
	if pm:IsControler(1-tp) then pm,om=om,pm end
	if pm:IsFacedown() then return end
	if Duel.SpecialSummonStep(om,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		om:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		om:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetOperation(c213333066.desop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		om:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
		local mat=Group.FromCards(pm,om)
		local g=Duel.GetMatchingGroup(c213333066.fsfil,tp,LOCATION_EXTRA,0,nil,e,tp,mat,nil)
		if pm:IsCanBeFusionMaterial() and om:IsCanBeFusionMaterial() and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1000,0)) then
			Duel.BreakEffect()
			local fg=g:Select(tp,1,1,nil)
			local fc=fg:GetFirst()
			fc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			fc:CompleteProcedure()
		end
	end
end
function c213333066.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
