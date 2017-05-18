--エンコード・トーカー
--Encode Talker
--Scripted by Eerie Code
function c100332041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERS),2,3)
end
