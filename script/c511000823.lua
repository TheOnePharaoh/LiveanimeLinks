--死のデッキ破壊ウイルス
function c511000823.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCost(c511000823.cost)
	e1:SetTarget(c511000823.target)
	e1:SetOperation(c511000823.activate)
	c:RegisterEffect(e1)
end
function c511000823.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackBelow(1000)
end
function c511000823.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c511000823.costfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,c511000823.costfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function c511000823.tgfilter(c)
	return c:IsFaceup() and c:GetAttack()>=1500 and c:IsDestructable()
end
function c511000823.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c511000823.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511000823.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(1500)
end
function c511000823.activate(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(tp,conf)
		local dg=conf:Filter(c511000823.filter,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(c511000823.desop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c511000823.turncon)
	e2:SetOperation(c511000823.turnop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e1)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetDescription(aux.Stringid(4931121,descnum))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetLabelObject(e2)
	e3:SetOwnerPlayer(tp)
	e3:SetOperation(c511000823.reset)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e3)
end
function c511000823.reset(e,tp,eg,ep,ev,re,r,rp)
	c511000823.turnop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c511000823.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(c511000823.filter,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.ShuffleHand(ep)
end
function c511000823.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c511000823.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==3 then
		e:GetLabelObject():Reset()
		if re then re:Reset() end
	end
end
