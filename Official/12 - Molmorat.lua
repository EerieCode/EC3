--十二獣モルモラット
--Molmorat of the Twelve Beasts
--Scripted by Eerie Code
function c7514.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7514,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c7514.tgtg)
	e1:SetOperation(c7514.tgop)
	c:RegisterEffect(e1)
	if not c7514.global_flag then
		c7514.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c7514.xspop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(0x40000)
		ge2:SetOperation(c7514.xmatop)
		Duel.RegisterEffect(ge2,0)
	end
end

function c7514.tgfilter(c)
	return c:IsSetCard(0xf2) and c:IsAbleToGrave()
end
function c7514.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7514.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c7514.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c7514.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c7514.xfil(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
		and bit.band(c:GetOriginalRace(),RACE_BEASTWARRIOR)==RACE_BEASTWARRIOR
		and ((c:GetMaterial() and c:GetMaterial():IsContains(mc)) or c:GetOverlayGroup():IsContains(mc))
		and c:GetFlagEffect(7514)==0
end
function c7514.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=eg:Filter(c7514.xfil,nil,c)
	local tc=mg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(7514,RESET_EVENT+0x1fc0000,0,1)
		local e1=c7514.zodiac_effect(c)
		tc:RegisterEffect(e1)
	end
end
function c7514.xmatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c7514.xfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local tc=mg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(7514,RESET_EVENT+0x1fc0000,0,1)
		local e1=c7514.zodiac_effect(c)
		tc:RegisterEffect(e1)
	end
end

function c7514.zodiac_effect(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(7514,1))
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_MZONE)
	e:SetCountLimit(1)
	e:SetCondition(c7514.spcon)
	e:SetCost(c7514.spcost)
	e:SetTarget(c7514.sptg)
	e:SetOperation(c7514.spop)
	e:SetReset(RESET_EVENT+0x1fc0000)
	return e
end
function c7514.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,7514)
end
function c7514.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7514.spfilter(c,e,tp)
	return c:IsCode(7514) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7514.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c7514.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c7514.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7514.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
