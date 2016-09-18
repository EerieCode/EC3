--スターヴ・ヴェノム・ベンジェンス・ドラゴン
--Starve Venom Vengeance Dragon
--Created by MasterGhost, scripted by Eerie Code
function c213456048.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c213456048.matfil1,c213456048.matfil2,false)
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c213456048.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c213456048.sppcon)
	e2:SetOperation(c213456048.sppop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c213456048.rmcon)
	e3:SetTarget(c213456048.rmtg)
	e3:SetOperation(c213456048.rmop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c213456048.aclimit)
	e4:SetCondition(c213456048.actcon)
	c:RegisterEffect(e4)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c213456048.pencon)
	e5:SetTarget(c213456048.pentg)
	e5:SetOperation(c213456048.penop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,213456048)
	e6:SetCost(c213456048.spcost)
	e6:SetTarget(c213456048.sptg)
	e6:SetOperation(c213456048.spop)
	c:RegisterEffect(e6)	
end

function c213456048.matfil1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT)
end
function c213456048.matfil2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_TOKEN)
end

function c213456048.splimit(e,se,sp,st)
	--return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_PZONE)
	--local loc=e:GetHandler():GetLocation()
	--return loc~=LOCATION_EXTRA and loc~=LOCATION_PZONE
	return se:GetHandler()==e:GetHandler() or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end

function c213456048.srmfil(c,fc)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
end
function c213456048.srmfil1(c,mg)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	return c213456048.matfil1(c) and mg2:IsExists(c213456048.matfil2,1,nil)
end
function c213456048.sppcon(e,c)
	if c==nil then return true end
	if c:IsFaceup() then return false end
	local tp=c:GetControler()
	--Debug.Message("Controler: "..tp)
	--Debug.Message("c: "..c:GetCode())
	local mg=Duel.GetMatchingGroup(c213456048.srmfil,tp,LOCATION_MZONE,0,nil,c)
	--Debug.Message("Removable monsters: "..mg:GetCount())
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and mg:IsExists(c213456048.srmfil1,1,nil,mg)
end
function c213456048.sppop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c213456048.srmfil,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=mg:FilterSelect(tp,c213456048.srmfil1,1,1,nil,mg,ft)
	local tc1=g1:GetFirst()
	mg:RemoveCard(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=mg:FilterSelect(tp,c213456048.matfil2,1,1,nil,mg,ft)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c213456048.rmcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c213456048.rmfil(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function c213456048.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c213456048.rmfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c213456048.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c213456048.rmfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct==0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500*ct)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end

function c213456048.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c213456048.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

function c213456048.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c213456048.penfil(c)
	return c:GetSequence()==6 or c:GetSequence()==7
end
function c213456048.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c213456048.penfil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c213456048.penop(e,tp,eg,ep,ev,re,r,rp)
	local str=_G["Place \"Starve Venom Vengeance Dragon\" in the Pendulum Zone?"]
	local g=Duel.GetMatchingGroup(c213456048.penfil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) and Duel.SelectYesNo(tp,str) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c213456048.spcfil(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT) and not c:IsType(TYPE_TOKEN) and c:IsAbleToGraveAsCost()
end
function c213456048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213456048.spcfil,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c213456048.spcfil,tp,LOCATION_MZONE,0,2,2,nil,tp)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c213456048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c213456048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
