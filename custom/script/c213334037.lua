--World’s End Circus - Mastermind Ringleader
--Created by Drakylon
--Scripted by Eerie Code
function c213334037.initial_effect(c)
	c:SetUniqueOnField(1,0,213334037)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3,c213334037.ovfilter,aux.Stringid(213334037,0))
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c213334037.thcon)
	e1:SetTarget(c213334037.thtg)
	e1:SetOperation(c213334037.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c213334037.rmcon)
	e2:SetCost(c213334037.rmcost)
	e2:SetTarget(c213334037.rmtg)
	e2:SetOperation(c213334037.rmop)
	c:RegisterEffect(e2)
	if not c213334037.global_check then
		c213334037.global_check=true
		c213334037[0]=0
		c213334037[1]=0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(c213334037.resetcount)
		Duel.RegisterEffect(e5,0)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetOperation(c213334037.addcount)
		Duel.RegisterEffect(e6,0)
	end
end

function c213334037.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetRank()==3
end

function c213334037.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()bit.band(:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c213334037.thfil(c)
	return c:IsSetCard(0x1edc) and c:IsAbleToHand()
end
function c213334037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213334037.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c213334037.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c213334037.thfil,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c213334037.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c213334037.splimit(e,c)
	return not c:IsSetCard(0x1edc)
end

function c213334037.rmcfil(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x1edc)
end
function c213334037.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c213334037.rmcfil,1,nil)
end
function c213334037.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() and tc:IsSetCard(0x1edc) and tc:IsType(TYPE_XYZ) then
			g:Merge(tc:GetOverlayGroup())
		end
	end
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c213334037.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c213334037[0]+c213334037[1]
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct*2,PLAYER_ALL,POS_FACEDOWN)
end
function c213334037.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c213334037[0]+c213334037[1]
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<ct and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	local g1=Duel.GetDecktopGroup(tp,ct)
	Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	local g2=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
end

function c213334037.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c213334037[0]=0
	c213334037[1]=0
end
function c213334037.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x1edc) and not tc:IsCode(213334037) then
			local p=tc:GetSummonPlayer()
			c213334037[p]=c213334037[p]+1
		end
		tc=eg:GetNext()
	end
end