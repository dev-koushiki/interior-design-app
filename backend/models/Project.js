const mongoose = require("mongoose");

const projectSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    projectName: {
      type: String,
      required: true,
      trim: true,
    },
    roomType: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      default: "",
    },
    originalImage: {
      type: String,
      default: "",
    },
    generatedDesigns: {
      type: [String],
      default: [],
    },
    status: {
      type: String,
      enum: ["Planning", "In Progress", "Completed"],
      default: "Planning",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Project", projectSchema);