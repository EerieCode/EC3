--リンク・スパイダー
--Link Spider
--Scripted by Eerie Code
function c100317043.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),1)
	--special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100317043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100317043.target)
	e1:SetOperation(c100317043.operation)
	c:RegisterEffect(e1)
end
function c100317043.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100317043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckLinkedLocation(c,tp)>0
		and Duel.IsExistingMatchingCard(c100317043.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100317043.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) 
		and Duel.CheckLinkedLocation(c,tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100317043.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,c:GetExtraZone(tp))
		end
	end
end
function Duel.CheckLinkedLocation(c,tp)
	if not tp then tp=PLAYER_ALL end
	local seq=c:GetSequence()
	local mark=c:GetTextDefense() --c:GetLinkMarker()
	local p=c:GetControler()
	local chk_own=(tp==PLAYER_ALL or c:IsControler(tp))
	local chk_opp=(tp==PLAYER_ALL or not c:IsControler(tp))
	--NOTE: This function assumes that the left EMzone is 5 and the right is 6
	local res=0
	if seq==5 then
		if chk_own then
			if bit.band(mark,8)~=0 and Duel.CheckLocation(p,LOCATION_MZONE,0) then res=res+1 end
			if bit.band(mark,16)~=0 and Duel.CheckLocation(p,LOCATION_MZONE,1) then res=res+1 end
			if bit.band(mark,32)~=0 and Duel.CheckLocation(p,LOCATION_MZONE,2) then res=res+1 end
		end
		if chk_opp then
			if bit.band(mark,128)~=0 and Duel.CheckLocation(1-p,LOCATION_MZONE,0) then res=res+1 end
			if bit.band(mark,1)~=0 and Duel.CheckLocation(1-p,LOCATION_MZONE,1) then res=res+1 end
			if bit.band(mark,2)~=0 and Duel.CheckLocation(1-p,LOCATION_MZONE,2) then res=res+1 end			
		end
	elseif seq==6 then
		if chk_own then
			if bit.band(mark,8)~=0 and Duel.CheckLocation(p,LOCATION_MZONE,2) then res=res+1 end
			if bit.band(mark,16)~=0 and Duel.CheckLocation(p,LOCATION_MZONE,3) then res=res+1 end
			if bit.band(mark,32)~=0 and Duel.CheckLocation(p,LOCATION_MZONE,4) then res=res+1 end
		end
		if chk_opp then
			if bit.band(mark,128)~=0 and Duel.CheckLocation(1-p,LOCATION_MZONE,2) then res=res+1 end
			if bit.band(mark,1)~=0 and Duel.CheckLocation(1-p,LOCATION_MZONE,3) then res=res+1 end
			if bit.band(mark,2)~=0 and Duel.CheckLocation(1-p,LOCATION_MZONE,4) then res=res+1 end			
		end
	else
		if bit.band(mark,4)~=0 and seq<4 and Duel.CheckLocation(p,LOCATION_MZONE,seq+1) then res=res+1 end
		if bit.band(mark,64)~=0 and seq>0 and Duel.CheckLocation(p,LOCATION_MZONE,seq-1) then res=res+1 end
	end
	return res
end
