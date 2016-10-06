--召喚獣エリュシオン
--Elysion the Eidolon Beast
--Scripted by Eerie Code
function c7633.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf4),c7633.mat_fil,false)
	
end

function c7633.mat_fil(c)
	return c:GetPreviousLocation()==LOCATION_EXTRA
end
