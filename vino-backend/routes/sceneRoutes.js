const express = require('express');
const router = express.Router();
const controller = require('../controllers/sceneController');

router.get('/', controller.getScenes);
router.get('/:id', controller.getScene);
router.post('/', controller.createScene);
router.put('/:id', controller.updateScene);
router.delete('/:id', controller.deleteScene);

module.exports = router;
