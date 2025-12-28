import Image from "next/image";

const screenshots = [
  {
    title: "Progress Tracking",
    description: "Visual charts showing your dog's training progress over time",
    image: "/screenshots/progress-dashboard.png",
  },
  {
    title: "Built-in Clicker",
    description: "Professional clicker training tool always at your fingertips",
    image: "/screenshots/clicker.png",
  },
  {
    title: "Command Library",
    description: "Step-by-step guides for teaching essential commands",
    image: "/screenshots/command-library.png",
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
          {screenshots.map((screen, index) => (
            <div key={index} className="flex flex-col items-center">
              {/* Phone Mockup with Real Screenshot */}
              <div className="relative w-full max-w-[240px] aspect-[9/19] rounded-[2.5rem] bg-gray-900 shadow-2xl overflow-hidden border-[8px] border-gray-900">
                {/* Phone Notch */}
                <div className="absolute top-0 left-1/2 -translate-x-1/2 w-24 h-6 bg-gray-900 rounded-b-2xl z-20" />

                {/* Screenshot Image */}
                <div className="relative w-full h-full overflow-hidden rounded-[2rem]">
                  <Image
                    src={screen.image}
                    alt={`${screen.title} screenshot`}
                    fill
                    className="object-cover object-top"
                    sizes="(max-width: 768px) 240px, 240px"
                  />
                </div>

                {/* Home Indicator */}
                <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-24 h-1 bg-white/30 rounded-full z-20" />
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
          ))}
        </div>
      </div>
    </section>
  );
}
