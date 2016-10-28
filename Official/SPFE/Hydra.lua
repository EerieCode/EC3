--捕食植物ドロソフィルム・ヒドラ
--Predator Plant Drosophyllum Hydra
--Scripted by Eerie Code
function c7601.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,7601)
	e1:SetCondition(c7601.hspcon)
	e1:SetOperation(c7601.hspop)
	c:RegisterEffect(e1)
end

function c7601.hspfilter(c)
	return c:GetCounter(0x1041)>0 and c:IsReleasable()
end
function c7601.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c7601.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	if g:IsExists(Card.IsControler,1,nil,tp) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function c7601.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if lc<0 then
		g=Duel.SelectMatchingCard(tp,c7601.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
	else
		g=Duel.SelectMatchingCard(tp,c7601.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	end
	Duel.Release(g,REASON_COST)
end
