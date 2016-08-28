--オッドアイズ・カタストロフ
--Odd-Eyes Catastrophe
--Created and scripted by Eerie Code
function c213456000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,213456000+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c213456000.cost)
	e1:SetTarget(c213456000.target)
	e1:SetOperation(c213456000.activate)
	c:RegisterEffect(e1)
end

function c213456000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	Duel.SetLP(tp,100)
end
function c213456000.f_tuner(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_TUNER) and Duel.IsExistingTarget(c213456000.f_nontuner,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function c213456000.f_nontuner(c,e,tp,tuner)
	local oex=tuner:IsSetCard(0x99) or c:IsSetCard(0x99)
	if c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_TUNER) and oex then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local bf=Duel.IsExistingMatchingCard(c213456000.fusion,tp,LOCATION_EXTRA,0,1,nil,e,tp,tuner,c,chkf)
		local bs=Duel.IsExistingMatchingCard(c213456000.synchro,tp,LOCATION_EXTRA,0,1,nil,e,tp,tuner,c)
		local bx=false
		if tuner:GetLevel()==c:GetLevel() then
			bx=Duel.IsExistingMatchingCard(c213456000.xyz,tp,LOCATION_EXTRA,0,1,nil,e,tp,tuner,c)
		else
			local max=math.max(tuner:GetLevel(),c:GetLevel())
			local sum=tuner:GetLevel()+c:GetLevel()
			bx=Duel.IsExistingMatchingCard(c213456000.xyz,tp,LOCATION_EXTRA,0,1,nil,e,tp,tuner,c,max,sum)
			--local ta1=Duel.CreateToken(tp,tuner:GetCode(),0,tuner:GetAttack(),tuner:GetDefence(),max,tuner:GetRace(),tuner:GetAttribute())
			--local ta2=Duel.CreateToken(tp,c:GetCode(),0,c:GetAttack(),c:GetDefence(),max,c:GetRace(),c:GetAttribute())
			--bx1=Duel.IsExistingMatchingCard(c213456000.xyz,tp,LOCATION_EXTRA,0,1,nil,e,tp,ta1,ta2)
		end
		return bf and bs and bx
	else return false end
end
function c213456000.fusion(c,e,tp,t,nt,chkf)
	local m=Group.FromCards(t,nt)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c213456000.synchro(c,e,tp,t,nt)
	local m=Group.FromCards(t,nt)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,m)
end
function c213456000.xyz(c,e,tp,t,nt,max,sum)
	local m=Group.FromCards(t,nt)
	if max then
		local b=c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ) and (c:GetRank()==max or c:GetRank()==sum) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c.xyz_count==2
		if c:IsCode(2978414) or c:IsCode(45627618) or c:IsCode(27337596) then
			return b and t:IsRace(RACE_DRAGON) and nt:IsRace(RACE_DRAGON)
		elseif c:IsCode(698785) then
			return b and t:IsType(TYPE_NORMAL) and nt:IsType(TYPE_NORMAL)
		elseif c:IsCode(18511599) or c:IsCode(74294676) or c:IsCode(42752141) then
			return b and t:IsRace(RACE_DINOSAUR) and nt:IsRace(RACE_DINOSAUR)
		elseif c:IsCode(91279700) or c:IsCode(36757171) then
			return b and t:IsSetCard(0xa) and nt:IsSetCard(0xa)
		else return b end
	else
		return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ) and m:FilterCount(c.xyz_filter,nil)==c.xyz_count
	end
end
function c213456000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c213456000.f_tuner,tp,LOCATION_MZONE,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (not Duel.IsPlayerAffectedByEffect(tp,29724053) or c29724053[tp]>=3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tun_g=Duel.SelectTarget(tp,c213456000.f_tuner,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tuner=tun_g:GetFirst()
	local nt_g=Duel.SelectTarget(tp,c213456000.f_nontuner,tp,LOCATION_MZONE,0,1,1,tuner,e,tp,tuner)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c213456000.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 then
		local t=tg:GetFirst()
		local nt=tg:GetNext()
		if nt:IsType(TYPE_TUNER) then t,nt=nt,t end
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fus_g=Duel.SelectMatchingCard(tp,c213456000.fusion,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,t,nt,chkf)
		if fus_g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local syn_g=Duel.SelectMatchingCard(tp,c213456000.synchro,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,t,nt)
		if syn_g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz_g=nil
		if t:GetLevel()==nt:GetLevel() then
			xyz_g=Duel.SelectMatchingCard(tp,c213456000.xyz,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,t,nt)
		else
			local max=math.max(t:GetLevel(),nt:GetLevel())
			local sum=t:GetLevel()+nt:GetLevel()
			xyz_g=Duel.SelectMatchingCard(tp,c213456000.xyz,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,t,nt,max,sum)
		end
		if xyz_g:GetCount()==0 then return end
		local fus=fus_g:GetFirst()
		local syn=syn_g:GetFirst()
		local xyz=xyz_g:GetFirst()
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==2 then
			tg:KeepAlive()
			Duel.SpecialSummonStep(fus,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonStep(syn,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(xyz,tg)
			Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
			fus:CompleteProcedure()
			syn:CompleteProcedure()
			xyz:CompleteProcedure()
		end
	end
end