--フェイタル・ヴェノム・コンタクト・ドラゴン
--Fatal Venom Contact Dragon
--Created and scripted by Eerie Code
function c213333045.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,41209827,c213333045.matfil,1,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c213333045.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c213333045.spcon)
	e2:SetOperation(c213333045.spop)
	e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	--Increase ATK
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c213333045.atkcon)
	e3:SetOperation(c213333045.atkop)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c213333045.negtg)
	e4:SetOperation(c213333045.negop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c213333045.svcon)
	e5:SetTarget(c213333045.svtg)
	e5:SetOperation(c213333045.svop)
	c:RegisterEffect(e5)
end

function c213333045.matfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_FUSION)
end

function c213333045.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c213333045.spfilter(c,tp,code)
	if not c:IsAbleToDeckOrExtraAsCost() then return false end
	if code then
		return c:IsType(TYPE_FUSION) and c:IsFusionCode(code) and Duel.IsExistingMatchingCard(c213333045.spfilter,tp,LOCATION_MZONE,0,1,c)
	else
		return c213333045.matfil(c)
	end
end
function c213333045.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	return Duel.IsExistingMatchingCard(c213333045.spfilter,tp,LOCATION_MZONE,0,1,nil,tp,41209827)
end
function c213333045.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c213333045.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,41209827)
	local tc1=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c213333045.spfilter,tp,LOCATION_MZONE,0,1,1,tc1)
	g:Merge(g2)
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c213333045.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()bit.band(:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c213333045.atkfil(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c213333045.atkop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c213333045.atkfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g,atk=mg:GetMaxGroup(Card.GetAttack)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end

function c213333045.negfil1(c,e)
	return aux.disfilter1(c) and c:IsLevelAbove(5) and not c:IsImmuneToEffect(e)
end
function c213333045.negfil2(c,e)
	return aux.disfilter1(c) and c:GetLevel()==0 and not c:IsImmuneToEffect(e)
end
function c213333045.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetMatchingGroup(c213333045.negfil1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	local mg2=Duel.GetMatchingGroup(c213333045.negfil2,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	local mc1=mg1:GetCount()
	local mg2=mg2:GetCount()
	if chk==0 then return mc1>0 or mc2>0 end
	local op=0
	if mc1>0 and mc2>0 then
		op=Duel.SelectOption(tp,aux.Stringid(1000,4),aux.Stringid(1000,5))
	elseif mc1>0 then
		op=Duel.SelectOption(tp,aux.Stringid(1000,4))
	else
		op=Duel.SelectOption(tp,aux.Stringid(1000,5))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,mg1,mc1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,mg2,mc2,0,0)
	end
end
function c213333045.negop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local g=nil
	if op==0 then
		g=Duel.GetMatchingGroup(c213333045.negfil1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	else
		g=Duel.GetMatchingGroup(c213333045.negfil2,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end

function c213333045.svcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and c:GetLocation()~=LOCATION_DECK
end
function c213333045.svfil(c,e,tp)
	return c:IsCode(41209827) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c213333045.svtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c213333045.svfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c213333045.svop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c213333045.svfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end
