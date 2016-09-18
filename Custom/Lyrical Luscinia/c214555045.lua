--ＬＬ－インディペンデント・ナイチンゲール
--Lyrical Luscinia - Independent Nightingale
--Altered by Isaiahj95, scripted by Eerie Code
function c214555045.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c214555045.matfil1,c214555045.matfil2,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c214555045.valcheck)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c214555045.atkval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,214555045)
	e4:SetTarget(c214555045.damtg)
	e4:SetOperation(c214555045.damop)
	c:RegisterEffect(e4)
	if not c214555045.global_check then
		c214555045.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(c214555045.checkop)
		Duel.RegisterEffect(ge1,tp)
	end
end

function c214555045.matfil1(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_XYZ)
end
function c214555045.matfil2(c)
	return c:GetLevel()==1
end

function c214555045.checkfil(c,tp)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c214555045.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return  end
	local sg=eg:Filter(c214555045.checkfil,nil,tp)
	local tc=sg:GetFirst()
	while tc do
		local oc=tc:GetOverlayCount()
		if oc>0 then
			for i=1,oc do
				tc:RegisterFlagEffect(214555045,RESET_EVENT+0x1fe0000-EVENT_TO_GRAVE,0,1)
			end
			--Debug.Message("Registered flag on "..tc:GetCode()..", value "..tc:GetFlagEffect(214555045))
		end
		tc=sg:GetNext()
	end
end

function c214555045.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local lv=0
	while tc do
		--Debug.Message("Card "..tc:GetCode()..", flag "..tc:GetFlagEffect(214555045))
		lv=lv+tc:GetFlagEffect(214555045)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end

function c214555045.atkval(e,c)
	return c:GetLevel()*500
end

function c214555045.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetLevel()*500)
end
function c214555045.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local lv=e:GetHandler():GetLevel()
	Duel.Damage(p,lv*500,REASON_EFFECT)
end
