--Vendread Reorigin
--Scripted by Eerie Code
function c101001085.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101001085.target)
	e1:SetOperation(c101001085.activate)
	c:RegisterEffect(e1)
end
function c101001085.filter(c,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsReleasableByEffect()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101001085+100,0x209,0x4011,0,0,c:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK)
end
function c101001085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c101001085.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101001085.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.SelectTarget(tp,c101001085.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101001085.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 then
		local token=Duel.CreateToken(tp,101001085,0x209,0,0,tc:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c101001085.splimit)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		token:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c101001085.splimit(e,c)
	return not c:IsSetCard(0x209)
end
