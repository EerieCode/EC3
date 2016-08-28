--地縛戒隷ジオグレムリーナ
--Earthbound Servant Geo Gremlina
--Altered by ScarletKing, scripted by Eerie Code
function c214445040.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1e21),2,true)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,214445040)
	e1:SetCondition(c214445040.damcon)
	e1:SetTarget(c214445040.damtg)
	e1:SetOperation(c214445040.damop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,214445040+1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c214445040.drcon)
	e2:SetTarget(c214445040.drtg)
	e2:SetOperation(c214445040.drop)
	c:RegisterEffect(e2)
	if not c214445040.global_check then
		c214445040.global_check=true
		c214445040[0]=false
		c214445040[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c214445040.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c214445040.clear)
		Duel.RegisterEffect(ge2,0)
	end
end

function c214445040.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if (tc:IsSetCard(0x1e21) or tc:IsSetCard(0x2e21)) and tc:IsPreviousLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c214445040.field,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) then
			c214445040[tc:GetPreviousControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c214445040.clear(e,tp,eg,ep,ev,re,r,rp)
	c214445040[0]=false
	c214445040[1]=false
end

function c214445040.field(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c214445040.damcfil(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==1-tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c214445040.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c214445040.damcfil,1,nil,tp) and Duel.IsExistingMatchingCard(c214445040.field,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c214445040.damfil(c)
	return c:IsFaceup() and (c:IsSetCard(0x1e21) or c:IsSetCard(0x2e21)) and c:IsAbleToGrave()
end
function c214445040.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c214445040.damfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c214445040.damfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c214445040.damfil,tp,LOCATION_GRAVE,0,1,99,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c214445040.damop(e,tp,eg,ep,ev,re,r,rp)
	local tg,p=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER)
	tg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
		local oc=Duel.GetOperatedGroup():GetCount()
		Duel.Damage(p,oc*1000,REASON_EFFECT)
	end
end

function c214445040.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c214445040[tp]
end
function c214445040.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c214445040.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
