--地縛戒隷ジオグリフォン
--Earthbound Servant Geo Gryphon
--Altered by ScarletKing, scripted by Eerie Code
function c214445051.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1e21),aux.NonTuner(nil),1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(c214445051.descon)
	e1:SetTarget(c214445051.destg)
	e1:SetOperation(c214445051.desop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,214445051)
	e2:SetCondition(aux.bdgcon)
	e2:SetCost(c214445051.spcost)
	e2:SetTarget(c214445051.sptg)
	e2:SetOperation(c214445051.spop)
	c:RegisterEffect(e2)
end

function c214445051.field(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c214445051.descfil(c,tp)
	return c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==1-tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c214445051.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg and eg:IsExists(c214445051.descfil,1,nil,tp) and (c:IsLocation(LOCATION_MZONE) or (eg:IsContains(c) and c214445051.descfil(c,tp))) and Duel.IsExistingMatchingCard(c214445051.field,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c214445051.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c214445051.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c214445051.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c214445051.spfil(c,e,tp)
	return (c:IsSetCard(0x1e21) or c:IsSetCard(0x2e21)) and not c:IsCode(214445051) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c214445051.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c214445051.spfil(chkc,e,tp) end
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return lc>0 and Duel.IsExistingTarget(c214445051.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then lc=1 end
	lc=min(lc,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c214445051.spfil,tp,LOCATION_GRAVE,0,1,lc,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c214445051.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
