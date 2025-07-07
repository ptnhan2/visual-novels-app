const model = require('../models/sceneModel');

exports.getScenes = async (req, res, next) => {
  try {
    const scenes = await model.getAllScenes();
    res.json(scenes);
  } catch (err) {
    next(err);
  }
};

exports.getScene = async (req, res, next) => {
  try {
    const scene = await model.getSceneById(req.params.id);
    if (!scene) return res.status(404).json({ error: 'Scene not found' });
    res.json(scene);
  } catch (err) {
    next(err);
  }
};

exports.createScene = async (req, res, next) => {
  try {
    const { content } = req.body;
    const newScene = await model.createScene(content);
    res.status(201).json(newScene);
  } catch (err) {
    next(err);
  }
};

exports.updateScene = async (req, res, next) => {
  try {
    const { content } = req.body;
    const updated = await model.updateScene(req.params.id, content);
    res.json(updated);
  } catch (err) {
    next(err);
  }
};

exports.deleteScene = async (req, res, next) => {
  try {
    await model.deleteScene(req.params.id);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};
