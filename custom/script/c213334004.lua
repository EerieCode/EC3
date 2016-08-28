--World’s End Circus - Styxwalking Acrobat
--Created by Drakylon
--Scripted by Eerie Code
function c213334004.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,213334004)
	e1:SetCost(c213334004.spcost)
	e1:SetTarget(c213334004.sptg)
	e1:SetOperation(c213334004.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c213334004.rmcon)
	e2:SetTarget(c213334004.rmtg)
	e2:SetOperation(c213334004.rmop)
	c:RegisterEffect(e2)
end

function c213334004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dt=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return dt:FilterCount(Card.IsAbleToRemoveAsCost,nil)==1 end
	Duel.Remove(dt,POS_FACEDOWN,REASON_COST)
end
function c213334004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c213334004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c213334004.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:FilterCount(Card.IsSetCard,nil,0x1edc)>0
end
function c213334004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 end
	Duel.SetTargetPlayer(tp)
end
function c213334004.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetDecktopGroup(1-p,3)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(p,g)
	local rg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
