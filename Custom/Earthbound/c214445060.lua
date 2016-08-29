--異界共鳴－シンクロ・フュージョン
--Underworld Resonance - Synchro Fusion
--Altered by F0futurehope, scripted by Eerie Code
function c214445060.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,214445060+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c214445060.con)
	e1:SetTarget(c214445060.tg)
	e1:SetOperation(c214445060.op)
	c:RegisterEffect(e1)
end

function c214445060.matfil(c,tp)
	return c:GetPreviousControler()~=tp or not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
end
function c214445060.spfil(c,e,tp,rc,lv,mg)
	return c:IsFacedown() and c:IsType(TYPE_FUSION) and c:IsRace(rc) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg)
end
function c214445060.cfil(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsControler(tp) and c:GetSummonPlayer()==tp and not c:GetMaterial():IsExists(c214445060.matfil,1,nil,tp) and Duel.IsExistingMatchingCard(c214445060.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRace(),c:GetLevel(),c:GetMaterial())
end
function c214445060.con(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c214445060.cfil,1,nil,e,tp)
end
function c214445060.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c214445060.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local sg=eg:Filter(c214445060.cfil,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local syn=sg:Select(tp,1,1,nil):GetFirst()
	local mat=syn:GetMaterial()
	local rc=syn:GetRace()
	local lv=syn:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fus=Duel.SelectMatchingCard(tp,c214445060.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rc,lv,mat):GetFirst()
	fus:SetMaterial(mat)
	Duel.SpecialSummon(fus,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
