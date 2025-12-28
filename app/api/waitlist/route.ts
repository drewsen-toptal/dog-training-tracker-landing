import { NextRequest, NextResponse } from "next/server";

// In production, you would connect to a database or email service
// For now, we'll store emails in a simple in-memory array (demo only)
const waitlistEmails: string[] = [];

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email } = body;

    // Validate email
    if (!email || typeof email !== "string") {
      return NextResponse.json(
        { success: false, message: "Email is required" },
        { status: 400 }
      );
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { success: false, message: "Invalid email format" },
        { status: 400 }
      );
    }

    // Check for duplicate
    if (waitlistEmails.includes(email.toLowerCase())) {
      return NextResponse.json(
        { success: false, message: "This email is already on the waitlist" },
        { status: 409 }
      );
    }

    // Add to waitlist (in production, save to database)
    waitlistEmails.push(email.toLowerCase());

    // Log for demo purposes
    console.log(`[Waitlist] New signup: ${email}`);
    console.log(`[Waitlist] Total signups: ${waitlistEmails.length}`);

    return NextResponse.json(
      {
        success: true,
        message: "Successfully joined the waitlist!",
        position: waitlistEmails.length
      },
      { status: 200 }
    );
  } catch (error) {
    console.error("[Waitlist] Error:", error);
    return NextResponse.json(
      { success: false, message: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function GET() {
  // Return waitlist stats (admin endpoint - protect in production)
  return NextResponse.json({
    count: waitlistEmails.length,
    message: "Waitlist stats"
  });
}
