import { TrendingUp, Radio, BookOpen } from "lucide-react";

const screenshots = [
  {
    title: "Progress Tracking",
    description: "Visual charts showing your dog's training progress over time",
    icon: TrendingUp,
    gradient: "from-blue-500/20 to-cyan-500/20",
  },
  {
    title: "Built-in Clicker",
    description: "Professional clicker training tool always at your fingertips",
    icon: Radio,
    gradient: "from-primary/20 to-secondary/20",
  },
  {
    title: "Command Library",
    description: "Step-by-step guides for teaching essential commands",
    icon: BookOpen,
    gradient: "from-purple-500/20 to-pink-500/20",
  },
];

export function AppScreenshots() {
  return (
    <section id="screenshots" className="py-16 md:py-20 lg:py-24 bg-background">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        {/* Section Header */}
        <div className="mx-auto mb-12 max-w-2xl text-center md:mb-16">
          <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
            Everything You Need in One App
          </h2>
          <p className="mt-4 text-muted-foreground">
            Simple, powerful tools designed for real dog training
          </p>
        </div>

        {/* Screenshots Grid */}
        <div className="grid gap-8 md:grid-cols-3 max-w-5xl mx-auto">
          {screenshots.map((screen, index) => {
            const Icon = screen.icon;
            return (
              <div key={index} className="flex flex-col items-center">
                {/* Phone Mockup */}
                <div
                  className={`relative w-full max-w-[240px] aspect-[9/16] rounded-3xl bg-gradient-to-br ${screen.gradient} shadow-2xl flex items-center justify-center border border-border overflow-hidden`}
                >
                  <div className="absolute inset-0 bg-grid-pattern opacity-5" />
                  <div className="text-center p-8 relative z-10">
                    <Icon className="h-16 w-16 mx-auto text-primary/60 mb-4" />
                    <div className="space-y-2">
                      <div className="h-2 bg-primary/20 rounded-full w-3/4 mx-auto" />
                      <div className="h-2 bg-primary/10 rounded-full w-full mx-auto" />
                      <div className="h-2 bg-primary/10 rounded-full w-5/6 mx-auto" />
                    </div>
                  </div>
                </div>

                {/* Description */}
                <div className="mt-6 text-center">
                  <h3 className="text-lg font-semibold text-foreground mb-2">
                    {screen.title}
                  </h3>
                  <p className="text-sm text-muted-foreground">
                    {screen.description}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
