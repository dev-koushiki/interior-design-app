const express = require("express");
const Project = require("./models/Project");
const cors = require("cors");
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose
  .connect(process.env.MONGO_URI)
  .then(() => {
    console.log("ArchiNest MongoDB connected successfully!");
  })
  .catch((error) => {
    console.error("MongoDB connection failed:", error.message);
  });

// User schema
const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

// Backend health check
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "ArchiNest backend is running!",
    database:
      mongoose.connection.readyState === 1
        ? "Connected"
        : "Disconnected",
  });
});

// Register API
app.post("/api/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Name, email, and password are required.",
      });
    }

    if (password.length < 8) {
      return res.status(400).json({
        success: false,
        message: "Password must be at least 8 characters long.",
      });
    }

    if (mongoose.connection.readyState !== 1) {
      return res.status(503).json({
        success: false,
        message: "Database is not connected.",
      });
    }

    const normalizedEmail = email.toLowerCase().trim();

    const existingUser = await User.findOne({
      email: normalizedEmail,
    });

    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: "An account with this email already exists.",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 12);

    const user = await User.create({
      name: name.trim(),
      email: normalizedEmail,
      password: hashedPassword,
    });

    return res.status(201).json({
      success: true,
      message: "Account created successfully!",
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error("Registration error:", error.message);

    return res.status(500).json({
      success: false,
      message: "Registration failed. Please try again.",
    });
  }
});

// Login API
app.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email and password are required.",
      });
    }

    if (mongoose.connection.readyState !== 1) {
      return res.status(503).json({
        success: false,
        message: "Database is not connected.",
      });
    }

    const normalizedEmail = email.toLowerCase().trim();

    const user = await User.findOne({
      email: normalizedEmail,
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password.",
      });
    }

    const isPasswordCorrect = await bcrypt.compare(
      password,
      user.password
    );

    if (!isPasswordCorrect) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password.",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Login successful!",
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error("Login error:", error.message);

    return res.status(500).json({
      success: false,
      message: "Login failed. Please try again.",
    });
  }
});

// CREATE A NEW PROJECT
app.post("/api/projects", async (req, res) => {
  try {
    const {
      userId,
      projectName,
      roomType,
      description,
      originalImage,
      generatedDesigns,
    } = req.body;

    if (!userId || !projectName || !roomType) {
      return res.status(400).json({
        success: false,
        message: "User ID, project name, and room type are required.",
      });
    }

    if (!mongoose.Types.ObjectId.isValid(userId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid user ID.",
      });
    }

    const project = new Project({
      userId,
      projectName,
      roomType,
      description: description || "",
      originalImage: originalImage || "",
      generatedDesigns: generatedDesigns || [],
    });

    await project.save();

    res.status(201).json({
      success: true,
      message: "Project created successfully!",
      project,
    });
  } catch (error) {
    console.error("Project creation error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to create project.",
    });
  }
});

// GET ALL PROJECTS FOR A USER
app.get("/api/projects/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(userId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid user ID.",
      });
    }

    const projects = await Project.find({ userId }).sort({
      createdAt: -1,
    });

    res.status(200).json({
      success: true,
      count: projects.length,
      projects,
    });
  } catch (error) {
    console.error("Fetch projects error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch projects.",
    });
  }
});

// DELETE A PROJECT
app.delete("/api/projects/:projectId", async (req, res) => {
  try {
    const { projectId } = req.params;
    const { userId } = req.body;

    if (
      !mongoose.Types.ObjectId.isValid(projectId) ||
      !mongoose.Types.ObjectId.isValid(userId)
    ) {
      return res.status(400).json({
        success: false,
        message: "Invalid project ID or user ID.",
      });
    }

    const project = await Project.findOneAndDelete({
      _id: projectId,
      userId,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: "Project not found.",
      });
    }

    res.status(200).json({
      success: true,
      message: "Project deleted successfully!",
    });
  } catch (error) {
    console.error("Delete project error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to delete project.",
    });
  }
});


// Add this route to your backend/server.js (after app and middleware setup,
// before app.listen). Requires multer and a server-side OPENAI_API_KEY in .env.
const multer = require('multer');
const designUpload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.mimetype)) {
      return cb(new Error('Please upload a JPG, PNG, or WebP room photo.'));
    }
    cb(null, true);
  },
});

app.post('/api/design/generate', designUpload.single('roomImage'), async (req, res) => {
  try {
    if (!process.env.OPENAI_API_KEY) {
      return res.status(503).json({
        success: false,
        message: 'AI generation is not configured. Add OPENAI_API_KEY to backend/.env.',
      });
    }
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'Room photo is required.' });
    }

    const { room, style, roomLength, roomWidth, roomHeight, measurementUnit } = req.body;
    const prompt = `Redesign the uploaded real ${room || 'room'} photo in a ${style || 'modern'} interior design style. Room dimensions supplied by the customer: ${roomLength || 'unknown'} x ${roomWidth || 'unknown'} x ${roomHeight || 'unknown'} ${measurementUnit || ''}. Create a photorealistic interior design proposal. Preserve the original room's camera angle, architecture, windows, doors, and overall layout. Add realistic, appropriately scaled furniture and tasteful decor. Do not add text, labels, or a collage. Return one complete room photograph.`;

    const form = new FormData();
    form.append('model', 'gpt-image-2.5-flare');
    form.append('prompt', prompt);
    form.append('size', '1536x1024');
    form.append('quality', 'medium');
    form.append('output_format', 'png');
    form.append('image', new Blob([req.file.buffer], { type: req.file.mimetype }), req.file.originalname || 'room.png');

    const apiResponse = await fetch('https://api.openai.com/v1/images/edits', {
      method: 'POST',
      headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}` },
      body: form,
    });
    const result = await apiResponse.json();
    if (!apiResponse.ok) {
      console.error('Image generation API error:', result);
      return res.status(502).json({
        success: false,
        message: result?.error?.message || 'The AI image service could not generate a design.',
      });
    }
    const imageBase64 = result?.data?.[0]?.b64_json;
    if (!imageBase64) {
      return res.status(502).json({ success: false, message: 'AI returned no image.' });
    }
    return res.json({ success: true, imageBase64 });
  } catch (error) {
    console.error('Design generation failed:', error);
    return res.status(500).json({ success: false, message: error.message || 'Design generation failed.' });
  }
});

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`ArchiNest backend running on port ${PORT}`);
});