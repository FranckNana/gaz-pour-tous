
class Bottle():

    def __init__(self, modifierId, bottleId, state, last_update, capacity):
        self.currentOwnerId = modifierId
        self.bottleId = bottleId
        self.state = state
        self.last_update = str(last_update)
        self.capacity = float(capacity)
        
    def __repr__(self):
        return "%d/%s/%s" % (self.currentOwnerId, self.bottleId, self.state)
    
