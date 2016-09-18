--融合の魔術師
--Fusion Magician
--Created and scripted by Eerie Code
function c213456028.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,213456028)
	e1:SetCost(c213456028.spcost1)
	e1:SetTarget(c213456028.sptg1)
	e1:SetOperation(c213456028.spop1)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c213456028.subcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c213456028.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c213456028.fscon)
	e4:SetTarget(c213456028.fstg)
	e4:SetOperation(c213456028.fsop)
	c:RegisterEffect(e4)
	if not c213456028.global_flag then
		c213456028.global_flag=true
		c213456028.pendulum_tokens_left={}
		c213456028.pendulum_tokens_left[0]=Group.CreateGroup()
		c213456028.pendulum_tokens_left[1]=Group.CreateGroup()
		c213456028.pendulum_tokens_left[0]:KeepAlive()
		c213456028.pendulum_tokens_left[1]:KeepAlive()
		c213456028.pendulum_tokens_right={}
		c213456028.pendulum_tokens_right[0]=Group.CreateGroup()
		c213456028.pendulum_tokens_right[1]=Group.CreateGroup()
		c213456028.pendulum_tokens_right[0]:KeepAlive()
		c213456028.pendulum_tokens_right[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_END)
		ge1:SetOperation(c213456028.ptop)
		Duel.RegisterEffect(ge1,tp)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,tp)
	end
end

function c213456028.ptop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		c213456028.pendulum_tokens_left[i]:Clear()
		local lc=Duel.GetFieldCard(i,LOCATION_SZONE,6)
		if lc then
			local tk=Duel.CreateToken(i,lc:GetCode())
			c213456028.pendulum_tokens_left[i]:AddCard(tk)
		end
		c213456028.pendulum_tokens_right[i]:Clear()
		local rc=Duel.GetFieldCard(i,LOCATION_SZONE,7)
		if rc then
			local tk=Duel.CreateToken(i,rc:GetCode())
			c213456028.pendulum_tokens_right[i]:AddCard(tk)
		end	 
	end
end

function c213456028.spfil0(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial()
end
function c213456028.spfil1(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c213456028.spfil2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c213456028.spcfil1(c)
	return c:IsSetCard(0x46) and c:IsAbleToRemoveAsCost()
end
function c213456028.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c213456028.spcfil1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c213456028.spcfil1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c213456028.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c213456028.spfil0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		local res=Duel.IsExistingMatchingCard(c213456028.spfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c213456028.spfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c213456028.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c213456028.spfil1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local sg1=Duel.GetMatchingGroup(c213456028.spfil2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c213456028.spfil2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

function c213456028.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end

function c213456028.regop(e,tp,eg,ep,ev,re,r,rp)
	if not bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then return end
	e:GetHandler():RegisterFlagEffect(213456028,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end

function c213456028.fscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(213456028)~=0
end
function c213456028.fsfil1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c213456028.fsfil2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c213456028.fsfil3(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c213456028.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
		mg1:Merge(c213456028.pendulum_tokens_left[tp])
		mg1:Merge(c213456028.pendulum_tokens_right[tp])
		local res=Duel.IsExistingMatchingCard(c213456028.fsfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c)
		return res 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c213456028.fsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c213456028.fsfil1,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	local sg1=Duel.GetMatchingGroup(c213456028.fsfil2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c)
	c213456028.ptop(e,tp,eg,ep,ev,re,r,rp)
	local mg2=mg1:Clone()
	mg2:Merge(c213456028.pendulum_tokens_left[tp])
	mg2:Merge(c213456028.pendulum_tokens_right[tp])
	local sg2=Duel.GetMatchingGroup(c213456028.fsfil2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,c)
	--Debug.Message("Summon w/o Pendulum: "..sg1:GetCount())
	--Debug.Message("Summon w Pendulum: "..sg2:GetCount())
	local pl=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local pr=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if sg2:GetCount()==0 and sg1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	elseif sg2:GetCount()>0 and ((pl and not pl:IsImmuneToEffect(e)) or (pr and not pr:IsImmuneToEffect(e))) then
		--Debug.Message("Entering prototype procedure...")
		local tkl=c213456028.pendulum_tokens_left[tp]:GetFirst()
		local tkr=c213456028.pendulum_tokens_right[tp]:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg2:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Group.FromCards(c)
		local ml=mat:Clone()
		ml:AddCard(pl)
		local tl=mat:Clone()
		if tkl then 
			tl:AddCard(tkl)
			--Debug.Message("Cards in tl: "..tl:GetFirst():GetCode()..", "..tl:GetNext():GetCode())
		end
		local tr=mat:Clone()
		if tkr then
			tr:AddCard(tkr)
			--Debug.Message("Cards in tr: "..tr:GetFirst():GetCode()..", "..tr:GetNext():GetCode())
		end
		local mr=mat:Clone()
		mr:AddCard(pr)
		--local bl=(tkl and tkl:IsCanBeFusionMaterial(tc))
		--local br=(tkr and tkr:IsCanBeFusionMaterial(tc))
		local bl=(tkl and tc:CheckFusionMaterial(Group.FromCards(tkl),c))
		local br=(tkr and tc:CheckFusionMaterial(Group.FromCards(tkr),c))
		--if sg1:IsContains(tc) then Debug.Message("Does not require Pendulum") end
		if bl then Debug.Message("Valid cards in left Zone") end
		if br then Debug.Message("Valid cards in right Zone") end
		--local mt=_G["c" .. tc:GetOriginalCode()]
		if (bl or br) and (not sg1:IsContains(tc) or Duel.SelectYesNo(tp,aux.Stringid(1002,3))) then
			--Debug.Message("Using Pendulum Materials")
			local mp=nil
			if bl and br then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local g=Duel.SelectMatchingCard(tp,c213456028.fsfil3,tp,LOCATION_SZONE,0,1,1,nil)
				mat:Merge(g)
				mp=g:GetFirst()
			elseif bl then
				mat=ml:Clone()
				mp=pl
			else
				mat=mr:Clone()
				mp=pr
			end
			--Debug.Message("Pendulum Material: "..mp)
			tc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			--Duel.SendtoExtraP(mp,nil,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			--Debug.Message("Why here?")
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
end
