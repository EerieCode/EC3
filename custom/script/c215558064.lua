--ＷＷの冷たい鐘
--Cold Chime of the Wind Witch
--Created by ScarletKing, scripted by Eerie Code
function c215558064.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c215558064.damcon)
	e1:SetTarget(c215558064.damtg)
	e1:SetOperation(c215558064.damop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c215558064.cost)
	e2:SetTarget(c215558064.tg)
	e2:SetOperation(c215558064.op)
	c:RegisterEffect(e2)
end

function c215558064.damcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and ep~=tp and rp==tp and rc and rc:IsType(TYPE_MONSTER) and rc:IsSetCard(0xf0)
end
function c215558064.damfil(c)
	return c:IsFaceup() and c:IsSetCard(0xf0) and c:GetBaseAttack()>0
end
function c215558064.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c215558064.damfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c215558064.damfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c215558064.damfil,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetBaseAttack())
end
function c215558064.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(p,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
	
function c215558064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c215558064.fil0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c215558064.fil1(c,tp,lv)
	return c:IsType(TYPE_TUNER) and c:GetLevel()<lv and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c215558064.fil2,tp,LOCATION_GRAVE,0,1,c,lv-c:GetLevel())
end
function c215558064.fil2(c,lv)
	return not c:IsType(TYPE_TUNER) and c:GetLevel()==lv and c:IsAbleToRemove()
end
function c215558064.cfil(c,e,tp)
	if c:IsFacedown() and c:IsSetCard(0xf0) then
		if c:IsType(TYPE_FUSION) then
			local mg0=Duel.GetMatchingGroup(c215558064.fil0,tp,LOCATION_GRAVE,0,nil)
			return Duel.GetFlagEffect(tp,215558064)==0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP_ATTACK) and c:CheckFusionMaterial(mg0)
		elseif c:IsType(TYPE_SYNCHRO) then
			return Duel.GetFlagEffect(tp,215558064+1)==0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(c215558064.fil1,tp,LOCATION_GRAVE,0,1,nil,tp,c:GetLevel())
		else return false end
	else return false end
end
function c215558064.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c215558064.cfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c215558064.cfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	if tc:IsType(TYPE_FUSION) then 
		Duel.RegisterFlagEffect(tp,215558064,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,215558064+1,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c215558064.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:IsFaceup() or not tc:IsLocation(LOCATION_EXTRA) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if tc:IsType(TYPE_FUSION) then
		local mg1=Duel.GetMatchingGroup(c215558064.fil0,tp,LOCATION_GRAVE,0,nil)
		if tc:CheckFusionMaterial(mg1) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	else
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mg1=Duel.SelectMatchingCard(tp,c215558064.fil1,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		if mg1:GetCount()==0 then return end
		local tc1=mg1:GetFirst()
		lv=lv-tc1:GetLevel()
		local mg2=Duel.SelectMatchingCard(tp,c215558064.fil2,tp,LOCATION_GRAVE,0,1,1,tc1,lv)
		mg2:AddCard(tc1)
		Duel.Remove(mg2,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
