import { AlertCircle, CreditCard, Wifi, Lock, Dog } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";

const frustrations = [
  {
    icon: CreditCard,
    quote: "I got charged $47 after what I thought was a 3-day trial. The cancel button was buried 6 screens deep.",
  },
  {
    icon: Dog,
    quote: "The app limits you to ONE dog. I have three. So I'm supposed to pay triple?",
  },
  {
    icon: Wifi,
    quote: "I was at the park with no signal and couldn't access any of my training logs. The whole point was to track our progress outside.",
  },
  {
    icon: Lock,
    quote: "Created an account, verified email, set up 2FA, forgot password, reset password... I just wanted to teach my dog to sit.",
  },
];

const comparisonTable = [
  { advertise: '"Free to download"', reality: "Paywall after 2 features" },
  { advertise: '"3-day free trial"', reality: "Charged on day 1 or 2" },
  { advertise: '"Just $9.99/month"', reality: "Auto-renews at $47/month" },
  { advertise: '"Unlimited access"', reality: "Limited to 1 dog" },
  { advertise: '"Works anywhere"', reality: "Requires constant internet" },
];

export function Problem() {
  return (
    <section className="py-16 md:py-20 lg:py-24 bg-muted/30">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        <div className="mx-auto max-w-4xl">
          {/* Section Header */}
          <div className="mb-12 text-center md:mb-16">
            <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
              Sound Familiar?
            </h2>
          </div>

          {/* Story */}
          <div className="mx-auto mb-12 max-w-3xl text-center">
            <p className="text-lg text-muted-foreground leading-relaxed">
              You downloaded a &ldquo;free&rdquo; dog training app. You spent 20 minutes setting up your profile,
              adding your dog&apos;s details, watching the tutorial videos.
            </p>
            <p className="mt-4 text-lg text-muted-foreground leading-relaxed">
              Then you hit the paywall.
            </p>
            <p className="mt-6 text-xl font-semibold text-foreground">
              &ldquo;Start your 3-day free trial!&rdquo; they said.
            </p>
            <div className="mt-6 inline-flex items-center gap-2 rounded-lg bg-destructive/10 px-4 py-3 text-destructive">
              <AlertCircle className="h-5 w-5" />
              <span className="font-mono font-semibold">-$47.99 - Recurring subscription</span>
            </div>
          </div>

          {/* Frustrations Grid */}
          <div className="mb-16">
            <h3 className="mb-8 text-center text-xl font-semibold">
              Real Frustrations From Real Dog Owners
            </h3>
            <div className="grid gap-4 md:grid-cols-2">
              {frustrations.map((item, index) => (
                <Card key={index} className="border-border/50">
                  <CardContent className="flex gap-4 p-6">
                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-muted">
                      <item.icon className="h-5 w-5 text-muted-foreground" />
                    </div>
                    <p className="text-sm text-muted-foreground italic">
                      &ldquo;{item.quote}&rdquo;
                    </p>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Comparison Table */}
          <div className="mx-auto max-w-2xl">
            <h3 className="mb-6 text-center text-xl font-semibold">
              The Real Cost of &ldquo;Free&rdquo; Apps
            </h3>
            <div className="overflow-hidden rounded-xl border border-border">
              <div className="grid grid-cols-2 bg-muted font-semibold">
                <div className="border-b border-r border-border p-4 text-sm">
                  What They Advertise
                </div>
                <div className="border-b border-border p-4 text-sm">
                  What You Actually Get
                </div>
              </div>
              {comparisonTable.map((row, index) => (
                <div key={index} className="grid grid-cols-2">
                  <div className="border-b border-r border-border p-4 text-sm text-muted-foreground last:border-b-0">
                    {row.advertise}
                  </div>
                  <div className="border-b border-border p-4 text-sm text-destructive last:border-b-0">
                    {row.reality}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Call to Action */}
          <p className="mt-10 text-center text-lg font-medium text-foreground">
            You deserve better than bait-and-switch pricing and artificial limits.
          </p>
        </div>
      </div>
    </section>
  );
}
