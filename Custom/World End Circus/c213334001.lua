--World’s End Circus - Blade Juggler
--Created by Drakylon
--Scripted by Eerie Code
function c213334001.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c213334001.settg)
	e1:SetOperation(c213334001.setop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c213334001.rmcon)
	e2:SetTarget(c213334001.rmtg)
	e2:SetOperation(c213334001.rmop)
	c:RegisterEffect(e2)
end

function c213334001.setfil(c)
	return c:IsPosition(POS_FACEDOWN) and c:IsAbleToRemove()
end
function c213334001.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c213334001.setfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c213334001.setfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c213334001.setfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c213334001.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c213334001.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0xedc)
end
function c213334001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 end
	Duel.SetTargetPlayer(tp)
end
function c213334001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetDecktopGroup(1-p,5)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(p,g)
	local rl=3
	local pd=Duel.GetDecktopGroup(p,1)
	if pd:GetCount()==0 or pd:FilterCount(Card.IsAbleToRemove,nil)==0 then rl=1 end
	local rg=g:FilterSelect(tp,Card.IsAbleToRemove,1,rl,nil)
	local rc=Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	if rc>1 then
		Duel.Remove(pd,POS_FACEDOWN,REASON_EFFECT)
	end
end
