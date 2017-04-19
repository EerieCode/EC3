--DDD超死偉王パープリッシュ・ヘル・アーマゲドン
--D/D/D Superdoom King Puprlish Armageddon
--Scripted by Eerie Code
function c100219002.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10af),2,true)
