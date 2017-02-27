--Parameters:
-- c:		The Link Monster
-- f:		Eventual filter for the Link Materials
-- ct:		Minimum number of Link Materials
-- maxc:	Maximum number of Link Materials (optional)

--Inferred functions:
-- Card.IsCanBeLinkMaterial:		Like the others, it checks whether a card can be used as a Link Material for that monster. I'm assuming it also checks whether that card is also worth an excessive number of Materials (ex. a LK3 monster used for a LK1 monster).
-- Card.GetExtraLocationCount:		Gets the number of Linked Zones usable for a Link Summon.
-- Card.IsOnLinkedZone:				Checks whether a card is in a Linked Zone. Needed to ensure that, if there are no free zones, a Material is first chosen from a Linked Zone.
-- Card.GetLinkMaterialValue:		Inspired by Card.GetSynchroLevel and Card.GetRitualLevel, this function returns the amount of Link Materials a card is worth for. The return value would be the LINK for a Link Monster, 1 for any other valid material.
-- Card.GetLink:					Returns a monster's LINK.
function Auxiliary.AddLinkProcedure(c,f,ct,maxc)
	if not maxc then maxc=c:GetLink() end
	--link procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetTarget(Auxiliary.LinkTarget(f,ct,maxc))
	e1:SetOperation(Auxiliary.LinkOperation(f,ct,maxc))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--cannot change position
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
end
function Auxiliary.LinkMatFilter(c,filter,lc)
	return c:IsFaceup() and (not filter or filter(c)) and c:IsCanBeLinkMaterial(lc)
end
function Auxiliary.LinkFFilter(c,mg,lc,ct,maxc)
	if c:IsControler() and c:IsLocation(LOCATION_MZONE)
		and c:IsOnLinkedZone() then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetLinkMaterialValue,lc:GetLink(),ct,maxc,lc)
	end
end
function Auxiliary.LinkTarget(f,ct,maxc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
			local c=e:GetHandler()
			local mg=Duel.GetMatchingGroup(Auxiliary.LinkMatFilter,tp,LOCATION_MZONE,0,1,nil,f,c)
			local ft=Duel.GetExtraLocationCount(tp)
			if chk==0 then
				if ft<0 then
					return mg:IsExists(Auxiliary.LinkFFilter,1,nil,mg,c,ct,maxc)
				else
					return mg:CheckWithSumEqual(Card.GetLinkMaterialValue,c:GetLink(),ct,maxc,lc)
				end
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LINK)
				mat=mg:SelectWithSumEqual(tp,Card.GetLinkMaterialValue,c:GetLink(),ct,maxc,c)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LINK)
				local tc=mg:Select(tp,1,1,nil):GetFirst()
				Duel.SetSelectedCard(tc)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LINK)
				mat=mg:SelectWithSumEqual(tp,Card.GetLinkMaterialValue,c:GetLink(),ct,maxc,c)
			end
			if mat then
				mat:KeepAlive()
				e:SetLabelObject(mat)
				return true
			else return false end
	end
end
function Auxiliary.LinkOperation(f,ct,maxc)
	return function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local g=e:GetLabelObject()
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
			g:DeleteGroup()
	end
end
