--リンク・ディサイプル
--Link Disciple
--Scripted by Eerie Code
function c100200132.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100200132.matfilter,1)
end
function c100200132.matfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_CYBERS)
end
