let currentEntityId = null;


function hideHealthBar(entityId) {
    let healthBar = document.getElementById("healthBar" + entityId);
    if (healthBar) {
        healthBar.style.display = "none";
        healthBar.remove();
    }
    if (currentEntityId === entityId) {
        currentEntityId = null;
    }
}

window.addEventListener('message', function(event) {

    var data = event.data;
    if (data.type === 'updateHealthBar') {
        let entityId = data.entityId;

        if (currentEntityId !== entityId) {
            hideHealthBar(currentEntityId);
        }

        let healthBar = document.getElementById("healthBar" + entityId);

        if (!healthBar) {
            let newHealthBar = `
                <div class="health-bar" id="healthBar${entityId}">
                    <div class="health-bar-text" id="healthBarText${entityId}">Health</div>
                    <div class="health-bar-inner" id="healthBarInner${entityId}"></div>
                </div>
            `;
            $('.wrapper').append(newHealthBar);
            healthBar = document.getElementById("healthBar" + entityId);
        }

        healthBar.style.left = data.x + "px";
        healthBar.style.top = data.y + "px";
        healthBar.style.display = "block";

        let healthBarInner = document.getElementById("healthBarInner" + entityId);
        let healthPercentage = (data.currentHealth / data.maxHealth) * 100;
        healthBarInner.style.width = healthPercentage + "%";

        let healthBarText = document.getElementById("healthBarText" + entityId);
        healthBarText.textContent = `${data.currentHealth} / ${data.maxHealth}`

        currentEntityId = entityId;
    } else if (data.type === 'hideHealthBar') {
        let entityId = data.entityId;
        hideHealthBar(entityId);
    }

});
