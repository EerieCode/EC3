--World’s End Circus - Dealer of Disaster
--Created by Drakylon
--Scripted by Eerie Code
function c213334005.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c213334005.spcon)
	e1:SetTarget(c213334005.sptg)
	e1:SetOperation(c213334005.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c213334005.precon)
	e2:SetOperation(c213334005.preop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c213334005.rmcon)
	e3:SetTarget(c213334005.rmtg)
	e3:SetOperation(c213334005.rmop)
	c:RegisterEffect(e3)	
end

function c213334005.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,gc,expt,expp=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if not ex or rp~=tp then return false end
	if expp and bit.band(expp,POS_FACEDOWN)==POS_FACEDOWN then return true end
	local rc=re:GetHandler()
	--All 'World End' cards that banish do it facedown
	if rc:IsSetCard(0xedc) then return true end
	--Check for 'BLS - Envoy of the Evening Twilight'
	if rc:IsCode(77498348) then return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) end
	--Check for BLS Ritual Summoned with 'Evening Twilight Knight'
	if rc:IsSetCard(0x10cf) and rc:IsType(TYPE_RITUAL) then return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) end
	--Remaining cards ('Ghostrick Skeleton', 'Esper Girl', 'Blue Duston', 'Different Dimension Capsule', 'Toon Kingdom', 'Lightforce Sword', 'PSY-Frame Overload', 'Phantom Hand')
	return rc:IsCode(51196805,99070951,40217358,11961740,43175858,49587034,36970611,40555959)
end
function c213334005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c213334005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c213334005.precon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2
end
function c213334005.preop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,3)
end

function c213334005.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c213334005.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg and eg:IsExists(Card.IsAbleToRemoveAsCost,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD) end
	local g=eg:Filter(Card.IsAbleToRemoveAsCost,nil)
	if g:GetCount()==1 then
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,POS_FACEDOWN)
end
function c213334005.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	else
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
